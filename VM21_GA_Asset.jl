using CSV, DataFrames, Tables

const MAX_ASS_DUR = 100
const MAX_SCEN = 2000

struct BondInfo
    face:: Float64
    dur:: Int64
    coupon:: Float64
    ytm:: Float64
end

# general account asset strategies
const BUY_PROPORTION = [0.2 0.3 0.5] # cash equity bond, must >= 0.0, must sum up to 1.0
const SELL_PROPORTION = [0.2 0.3 0.5] # cash equity bond, must >= 0.0, must sum up to 1.0
const INV_EXP = [0.0 0.0 0.0] # cash equity bond
const BOND_SPREAD = [0.0071935 0.008968 0.0107425 0.012517] #1-4yr
const BOND_DEFAULT = [-0.000332252409739937 0.000111372590260063 0.000554997590260063 0.000998622590260063] #1-4yr
const IF_BOND = BondInfo(0.0, 20, 0.02, 0.02) # face dur coupon ytm
const NEW_BOND = BondInfo(-1.0, 10, 0.02, -1.0) # face=tbd dur coupon ytm=tbd
const REBALANCE_TARGET_PROPORTION = [0.2 0.3 0.5] # cash equity bond

function NetPresentValue(rate, cashflow)
    pv = 0.0
    for c in length(cashflow):(-1):1
        if c > 0.0
            pv += cashflow[c]
            pv /= (1 + rate)
        end
    end
    return pv
end

function GeneralAccountAssetLiability(scen_num, return_array, ga_liab_cf, init_bal)
    asset_bf_rb = zeros(3, MAX_ASS_DUR) # cash equity bond
    asset_af_rb = zeros(3, MAX_ASS_DUR) # cash equity bond
    asset_to_buy = zeros(3, MAX_ASS_DUR) # cash equity bond
    asset_to_sell = zeros(3, MAX_ASS_DUR) # cash equity bond
    asset_to_rebalance = zeros(3, MAX_ASS_DUR) # cash equity bond
    rebalance_target = zeros(MAX_ASS_DUR)
    if_bond_cf = zeros(MAX_ASS_DUR)
    new_bond_cf = zeros(MAX_ASS_DUR, MAX_ASS_DUR * 2)
    acc_scaled_new_bond_cf = zeros(MAX_ASS_DUR * 2)

    # inforce bond cashflow
    if sum(ga_liab_cf) > 0.0
        for y in 1:IF_BOND.dur
            if_bond_cf[y] = IF_BOND.face * IF_BOND.coupon
            if y == IF_BOND.dur
                if_bond_cf[y] += IF_BOND.face
            end
        end
    else
        for y in 1:NEW_BOND.dur
            if_bond_cf[y] = init_bal[3] * NEW_BOND.coupon
            if y == NEW_BOND.dur
                if_bond_cf[y] += init_bal[3]
            end
        end
    end

    for y in 1:MAX_ASS_DUR
        asset_ret = [return_array[5, y, scen_num] - INV_EXP[1], # 5 for MONEY
            return_array[1, y, scen_num] - INV_EXP[2], # 1 for US
            return_array[10, y, scen_num] + BOND_SPREAD[min(y, 4)] - BOND_DEFAULT[min(y, 4)] - INV_EXP[3]] # 10 for UST 10Y
        if y == 1
            # buy
            for i in 1:2
                asset_to_buy[i, y] = init_bal[i] * max(asset_ret[i], 0.0) + max(sum(ga_liab_cf[((y - 1) * 12 + 2):(y * 12 + 1)]), 0.0) * BUY_PROPORTION[i]
            end
            asset_to_buy[3, y] = max(sum(ga_liab_cf[((y - 1) * 12 + 2):(y * 12 + 1)]), 0.0) * BUY_PROPORTION[3] + if_bond_cf[y]
            # sell
            for i in 1:2
                asset_to_sell[i, y] = init_bal[i] * min(asset_ret[i], 0.0) + min(sum(ga_liab_cf[((y - 1) * 12 + 2):(y * 12 + 1)]), 0.0) * SELL_PROPORTION[i]
            end
            asset_to_sell[3, y] = min(sum(ga_liab_cf[((y - 1) * 12 + 2):(y * 12 + 1)]), 0.0) * SELL_PROPORTION[3]
            # rebalance
            for i in 1:3
                asset_bf_rb[i, y] = init_bal[i] + asset_to_buy[i, y] + asset_to_sell[i, y]
            end
            bond_natural_increase = 0.0
            if REBALANCE_TARGET_PROPORTION[3] > 0.0
                bond_natural_increase = NetPresentValue(asset_ret[3], if_bond_cf[(y + 1):end])
            end
            target_total = sum(init_bal) + sum(asset_to_buy[:, y]) + sum(asset_to_sell[:, y]) + bond_natural_increase - init_bal[3]
            for i in 1:3
                if REBALANCE_TARGET_PROPORTION[i] > 0.0
                    asset_to_rebalance[i, y] = REBALANCE_TARGET_PROPORTION[i] * target_total - init_bal[i] - asset_to_buy[i, y] - asset_to_sell[i, y]
                end
            end
            asset_to_rebalance[3, y] -= (bond_natural_increase - init_bal[3])
            for x in 1:NEW_BOND.dur
                new_bond_cf[y, y + x] = (asset_to_buy[3, y] + asset_to_sell[3, y] + asset_to_rebalance[3, y]) * NEW_BOND.coupon
                if x == NEW_BOND.dur
                    new_bond_cf[y, y + x] += (asset_to_buy[3, y] + asset_to_sell[3, y] + asset_to_rebalance[3, y])
                end
            end
            for i in 1:2
                asset_af_rb[i, y] = init_bal[i] + asset_to_buy[i, y] + asset_to_sell[i, y] + asset_to_rebalance[i, y]
            end
            scale = asset_to_buy[3, y] + asset_to_sell[3, y] + asset_to_rebalance[3, y]
            if abs(NetPresentValue(asset_ret[3], new_bond_cf[y, (y + 1):end])) > 0.0
                scale /= NetPresentValue(asset_ret[3], new_bond_cf[y, (y + 1):end])
            end
            for x in 1:NEW_BOND.dur
                acc_scaled_new_bond_cf[y + x] = new_bond_cf[y, y + x] * scale
            end
            asset_af_rb[3, y] = NetPresentValue(asset_ret[3], if_bond_cf[(y + 1):end]) + NetPresentValue(asset_ret[3], acc_scaled_new_bond_cf[(y + 1):end])
        else
            # buy
            for i in 1:2
                asset_to_buy[i, y] = asset_af_rb[i, y - 1] * max(asset_ret[i], 0.0) + max(sum(ga_liab_cf[((y - 1) * 12 + 2):(y * 12 + 1)]), 0.0) * BUY_PROPORTION[i]
            end
            asset_to_buy[3, y] = max(sum(ga_liab_cf[((y - 1) * 12 + 2):(y * 12 + 1)]), 0.0) * BUY_PROPORTION[3] + if_bond_cf[y] + acc_scaled_new_bond_cf[y]
            # sell
            for i in 1:2
                asset_to_sell[i, y] = asset_af_rb[i, y - 1] * min(asset_ret[i], 0.0) + min(sum(ga_liab_cf[((y - 1) * 12 + 2):(y * 12 + 1)]), 0.0) * SELL_PROPORTION[i]
            end
            asset_to_sell[3, y] = min(sum(ga_liab_cf[((y - 1) * 12 + 2):(y * 12 + 1)]), 0.0) * SELL_PROPORTION[3]
            # rebalance
            for i in 1:3
                asset_bf_rb[i, y] = asset_af_rb[i, y - 1] + asset_to_buy[i, y] + asset_to_sell[i, y]
            end
            bond_natural_increase = 0.0
            if REBALANCE_TARGET_PROPORTION[3] > 0.0
                bond_natural_increase = NetPresentValue(asset_ret[3], if_bond_cf[(y + 1):end]) + NetPresentValue(asset_ret[3], acc_scaled_new_bond_cf[(y + 1):end])
            end
            target_total = sum(asset_af_rb[:, y - 1]) + sum(asset_to_buy[:, y]) + sum(asset_to_sell[:, y]) + bond_natural_increase - asset_af_rb[3, y - 1]
            for i in 1:3
                if REBALANCE_TARGET_PROPORTION[i] > 0.0
                    asset_to_rebalance[i, y] = REBALANCE_TARGET_PROPORTION[i] * target_total - asset_af_rb[i, y - 1] - asset_to_buy[i, y] - asset_to_sell[i, y]
                end
            end
            asset_to_rebalance[3, y] -= (bond_natural_increase - asset_af_rb[3, y - 1])
            for x in 1:NEW_BOND.dur
                new_bond_cf[y, y + x] = (asset_to_buy[3, y] + asset_to_sell[3, y] + asset_to_rebalance[3, y]) * NEW_BOND.coupon
                if x == NEW_BOND.dur
                    new_bond_cf[y, y + x] += (asset_to_buy[3, y] + asset_to_sell[3, y] + asset_to_rebalance[3, y])
                end
            end
            for i in 1:2
                asset_af_rb[i, y] = asset_af_rb[i, y - 1] + asset_to_buy[i, y] + asset_to_sell[i, y] + asset_to_rebalance[i, y]
            end
            scale = asset_to_buy[3, y] + asset_to_sell[3, y] + asset_to_rebalance[3, y]
            if abs(NetPresentValue(asset_ret[3], new_bond_cf[y, (y + 1):end])) > 0.0
                scale /= NetPresentValue(asset_ret[3], new_bond_cf[y, (y + 1):end])
            end
            for x in 1:NEW_BOND.dur
                acc_scaled_new_bond_cf[y + x] += new_bond_cf[y, y + x] * scale
            end
            asset_af_rb[3, y] = NetPresentValue(asset_ret[3], if_bond_cf[(y + 1):end]) + NetPresentValue(asset_ret[3], acc_scaled_new_bond_cf[(y + 1):end])
        end
    end

    return sum(asset_af_rb, dims = 1)
end