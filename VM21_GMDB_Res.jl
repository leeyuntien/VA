using CSV, DataFrames, Tables

include("VM21_GA_Asset.jl")

# policy
const GENDER = 1
const ISSUE_AGE = 41
const ACC_PERIOD = 54 # to 95
const SINGLE_PREMIUM = 100000
const INITIAL_T = 1 # starting from 1
const INITIAL_AV = 0 # initial account value
const INITIAL_GV = 100000 # initial guarantee value
const MAX_LIAB_DUR = 1440
const MAX_SCEN = 2000

# charge and expense
const POLICY_CHARGE = 0.035
const MANAGEMENT_CHARGE = 0.011 # annual rate
const CUSTODIAN_CHARGE = 0.0004 # annual rate equal to custodian fee
const GUARANTEE_CHARGE = [0.00026 0.00015; 0.00037 0.00022; 0.00053 0.00033; 0.00076 0.00048; 0.00108 0.00071; 0.00154 0.00104] # monthly rate, issue age 41-45, 46-50, 51-55, 56-60, 61-65, 66-70, gender M-F
const NET_REBATE = 0.0075 # annual rate
const COMM_RATE = 0.03 * (1 + 1.55) # including override
const FX_RATE = 28.5
const ACQ_EXP_FIXED = (1200 + 1000 + 730) / FX_RATE
const ACQ_EXP_PREM = 0.0005
const MAINT_EXP_FIXED = [300 / FX_RATE 100]
const MAINT_EXP_AV = [0 0.0007]
const OH_EXP_FIXED = [300 / FX_RATE 0]
const INF_RATE = [0.0176 0.02]
const PREM_TAX_RATE = [0.05 0.02] # policy charges, rebate
const STAB_FUND_RATE = 0.0019
const REG_FEE_RATE = 0.0003
const CONSUM_PROTECT_FEE_RATE = 0.00008
const PART_WD_RATE = [0 0.035] # sr ppa
const GAPV_DISC_RATE = 0.013 # 10 year UST as of August 2021

# read scenario
const RealWorldScenarioPath = "../scenario_100years/"
const RealWorldScenarioFileNames = ["US.csv", "INT.csv", "SMALL.csv", "AGGR.csv", "MONEY.csv", "INTGOV.csv", "LTCORP.csv", "FIXED.csv", "BALANCED.csv", "UST_10y.csv"]
return_array = zeros(10, MAX_LIAB_DUR, MAX_SCEN)
return_weight = zeros(10)
for i in 1:9
    r = CSV.File(RealWorldScenarioPath * RealWorldScenarioFileNames[i], header = false) |> DataFrame
    for j in 1:100
        for k in 1:1000
            return_array[i, j, k] = r[k, j * 12 + 1] / r[k, (j - 1) * 12 + 1] - 1
        end
    end
end
i = 10
r = CSV.File(RealWorldScenarioPath * RealWorldScenarioFileNames[i], header = false) |> DataFrame
for j in 1:100
    for k in 1:1000
        return_array[i, j, k] = r[k, j * 12 + 1]
    end
end
return_weight[1] = 1.0 # all US

# read mortality rate
const SRMortalityTableFile = "TSO11.csv" # attained age 0-110 gender M-F for stochastic reserve
const PPAMortalityTableFile = "TWVAnn.csv" # policy year 1-60 issue age gender 41M-80F for ppa reserve
sr_mortality = CSV.File(SRMortalityTableFile, header = false) |> DataFrame
ppa_mortality = CSV.File(PPAMortalityTableFile, header = false) |> DataFrame

# lapse rate
const lapse_rate_sr = [0.15 0.1 0.15; 0.1 0.05 0.15] # 1yr, 2-yr
const lapse_rate_ppa = [0.04 0.03 0.025 0.025 0.025 0.025 0.025 0.025; 0.15 0.1 0.07 0.045 0.03 0.025 0.02 0.02] # 1-3yr, 4-yr
const lapse_mult = [0.75, 1, 1.5, 0.6] # GMDB, GMWB, GMAB, all

# gapv gmdb
gapv_gmdb_life_factor = zeros(MAX_LIAB_DUR) # GMDB max period = 54 * 12
gapv_gmdb_life_factor[(100 - ISSUE_AGE) * 12 - INITIAL_T + 2] = 1.0
for t in ((100 - ISSUE_AGE) * 12 - INITIAL_T + 1):(-1):INITIAL_T
    # ppa mortality
    qd = 1.0 - (1.0 - ppa_mortality[cld(t, 12), ISSUE_AGE - 40 + (GENDER - 1) * 40]) ^ (1.0 / 12)
    gapv_gmdb_life_factor[t] = qd + gapv_gmdb_life_factor[t + 1] / ((1 + GAPV_DISC_RATE) ^ (1.0 / 12)) * (1 - qd)
end

floored_gpvad_sr = zeros(MAX_SCEN)
unfloored_gpvad_sr = zeros(MAX_SCEN)
floored_gpvad_ppa = zeros(MAX_SCEN)
for scen_num in 1:1000
    println("scenario ", scen_num)
    # decrement, account value and guarantee value
    lives_sr = zeros(MAX_LIAB_DUR) # GMDB max period = 54 * 12
    av_sr = zeros(MAX_LIAB_DUR) # GMDB max period = 54 * 12
    gv_sr = zeros(MAX_LIAB_DUR) # GMDB max period = 54 * 12
    ga_sr = zeros(MAX_LIAB_DUR) # GMDB max period = 54 * 12
    lives_ppa = zeros(MAX_LIAB_DUR) # GMDB max period = 54 * 12
    av_ppa = zeros(MAX_LIAB_DUR) # GMDB max period = 54 * 12
    gv_ppa = zeros(MAX_LIAB_DUR) # GMDB max period = 54 * 12
    ga_ppa = zeros(MAX_LIAB_DUR) # GMDB max period = 54 * 12
    lives_sr[1] = 1.0
    av_sr[1] = INITIAL_AV
    gv_sr[1] = INITIAL_GV
    lives_ppa[1] = 1.0
    av_ppa[1] = INITIAL_AV
    gv_ppa[1] = INITIAL_GV
    for t in (INITIAL_T + 1):(ACC_PERIOD * 12 - INITIAL_T + 2)
        # sr mortality
        qd = 1.0 - (1.0 - sr_mortality[ISSUE_AGE + cld(t - 1, 12), GENDER]) ^ (1.0 / 12)

        # sr account value
        gt = av_sr[t - 1] * GUARANTEE_CHARGE[cld(ISSUE_AGE, 5) - 8, GENDER]
        mg = av_sr[t - 1] * MANAGEMENT_CHARGE / 12
        cu = av_sr[t - 1] * CUSTODIAN_CHARGE / 12
        pw = av_sr[t - 1] * PART_WD_RATE[1] / 12
        rb = av_sr[t - 1] * NET_REBATE / 12
        if t <= 13
            exp = ACQ_EXP_FIXED / 12
        else
            exp = (MAINT_EXP_FIXED[1] + OH_EXP_FIXED[1]) / 12 * (1.0 + INF_RATE[1]) ^ (cld(t - 1, 12) - 1)
        end
        exp += (STAB_FUND_RATE + PREM_TAX_RATE[1]) * gt + (REG_FEE_RATE + CONSUM_PROTECT_FEE_RATE) * (gt + rb) + PREM_TAX_RATE[2] * rb # at start the incremental item is 0
        av_sr[t] = av_sr[t - 1]
        if t == 2
            gt = SINGLE_PREMIUM * (1.0 - POLICY_CHARGE) * GUARANTEE_CHARGE[cld(ISSUE_AGE, 5) - 8, GENDER]
            mg = SINGLE_PREMIUM * (1.0 - POLICY_CHARGE) * (1.0 - GUARANTEE_CHARGE[cld(ISSUE_AGE, 5) - 8, GENDER]) * MANAGEMENT_CHARGE / 12
            cu = SINGLE_PREMIUM * (1.0 - POLICY_CHARGE) * (1.0 - GUARANTEE_CHARGE[cld(ISSUE_AGE, 5) - 8, GENDER]) * CUSTODIAN_CHARGE / 12
            pw = SINGLE_PREMIUM * (1.0 - POLICY_CHARGE) * (1.0 - GUARANTEE_CHARGE[cld(ISSUE_AGE, 5) - 8, GENDER]) * PART_WD_RATE[1] / 12
            rb = SINGLE_PREMIUM * (1.0 - POLICY_CHARGE) * (1.0 - GUARANTEE_CHARGE[cld(ISSUE_AGE, 5) - 8, GENDER]) * NET_REBATE / 12
            exp += ACQ_EXP_PREM * SINGLE_PREMIUM
            exp += (STAB_FUND_RATE + PREM_TAX_RATE[1]) * gt + (REG_FEE_RATE + CONSUM_PROTECT_FEE_RATE) * (gt + rb) + PREM_TAX_RATE[2] * rb
            exp += (STAB_FUND_RATE + PREM_TAX_RATE[1]) * (SINGLE_PREMIUM * POLICY_CHARGE) + (REG_FEE_RATE + CONSUM_PROTECT_FEE_RATE) * (SINGLE_PREMIUM * POLICY_CHARGE)
            av_sr[t] += SINGLE_PREMIUM * (1.0 - POLICY_CHARGE)
            ga_sr[t] = -SINGLE_PREMIUM * COMM_RATE + SINGLE_PREMIUM * POLICY_CHARGE
        end
        av_sr[t] = (1.0 + sum(return_weight .* return_array[:, cld(t - 1, 12), scen_num])) ^ (1.0 / 12) * (av_sr[t] - gt - mg - cu - pw)
        gv_sr[t] = gv_sr[t - 1] * (1.0 - pw / av_sr[t])
        ga_sr[t] += gt + rb - exp - cu - qd * max(0, gv_sr[t] - av_sr[t])

        # sr lapse
        if t <= 13
            qw = 1.0 - (1.0 - min(lapse_rate_sr[1, 3], max(lapse_rate_sr[1, 2], lapse_rate_sr[1, 1] * (av_sr[t] / gv_sr[t]) ^ 3))) ^ (1.0 / 12)
        else
            qw = 1.0 - (1.0 - min(lapse_rate_sr[2, 3], max(lapse_rate_sr[2, 2], lapse_rate_sr[2, 1] * (av_sr[t] / gv_sr[t]) ^ 3))) ^ (1.0 / 12)
        end
        if av_sr[t] <= 0.0
            lives_sr[t] = 0.0
        else
            lives_sr[t] = lives_sr[t - 1] * (1.0 - qd) * (1.0 - qw)
        end

        # ppa mortality
        qd = 1.0 - (1.0 - ppa_mortality[cld(t - 1, 12), ISSUE_AGE - 40 + (GENDER - 1) * 40]) ^ (1.0 / 12)

        # ppa account value
        gt = av_ppa[t - 1] * GUARANTEE_CHARGE[cld(ISSUE_AGE, 5) - 8, GENDER]
        mg = av_ppa[t - 1] * MANAGEMENT_CHARGE / 12
        cu = av_ppa[t - 1] * CUSTODIAN_CHARGE / 12
        pw = av_ppa[t - 1] * PART_WD_RATE[2] / 12
        rb = av_ppa[t - 1] * NET_REBATE / 12
        exp = (MAINT_EXP_FIXED[2] + OH_EXP_FIXED[2]) / 12 * (1.0 + INF_RATE[2]) ^ (cld(t - 1, 12) - 1)
        exp += (STAB_FUND_RATE + PREM_TAX_RATE[1]) * gt + (REG_FEE_RATE + CONSUM_PROTECT_FEE_RATE) * (gt + rb) + PREM_TAX_RATE[2] * rb # at start the incremental item is 0
        exp += MAINT_EXP_AV[2] / 12 * av_ppa[t - 1] # at start the incremental item is 0
        av_ppa[t] = av_ppa[t - 1]
        if t == 2
            gt = SINGLE_PREMIUM * (1.0 - POLICY_CHARGE) * GUARANTEE_CHARGE[cld(ISSUE_AGE, 5) - 8, GENDER]
            mg = SINGLE_PREMIUM * (1.0 - POLICY_CHARGE) * (1.0 - GUARANTEE_CHARGE[cld(ISSUE_AGE, 5) - 8, GENDER]) * MANAGEMENT_CHARGE / 12
            cu = SINGLE_PREMIUM * (1.0 - POLICY_CHARGE) * (1.0 - GUARANTEE_CHARGE[cld(ISSUE_AGE, 5) - 8, GENDER]) * CUSTODIAN_CHARGE / 12
            pw = SINGLE_PREMIUM * (1.0 - POLICY_CHARGE) * (1.0 - GUARANTEE_CHARGE[cld(ISSUE_AGE, 5) - 8, GENDER]) * PART_WD_RATE[2] / 12
            rb = SINGLE_PREMIUM * (1.0 - POLICY_CHARGE) * (1.0 - GUARANTEE_CHARGE[cld(ISSUE_AGE, 5) - 8, GENDER]) * NET_REBATE / 12
            exp += MAINT_EXP_AV[2] / 12 * SINGLE_PREMIUM * (1.0 - POLICY_CHARGE) * (1.0 - GUARANTEE_CHARGE[cld(ISSUE_AGE, 5) - 8, GENDER])
            exp += (STAB_FUND_RATE + PREM_TAX_RATE[1]) * gt + (REG_FEE_RATE + CONSUM_PROTECT_FEE_RATE) * (gt + rb) + PREM_TAX_RATE[2] * rb
            exp += (STAB_FUND_RATE + PREM_TAX_RATE[1]) * (SINGLE_PREMIUM * POLICY_CHARGE) + (REG_FEE_RATE + CONSUM_PROTECT_FEE_RATE) * (SINGLE_PREMIUM * POLICY_CHARGE)
            av_ppa[t] += SINGLE_PREMIUM * (1.0 - POLICY_CHARGE)
            ga_ppa[t] = -SINGLE_PREMIUM * COMM_RATE + SINGLE_PREMIUM * POLICY_CHARGE
        end
        av_ppa[t] = (1.0 + sum(return_weight .* return_array[:, cld(t - 1, 12), scen_num])) ^ (1.0 / 12) * (av_ppa[t] - gt - mg - cu - pw)
        gv_ppa[t] = gv_ppa[t - 1] * (1.0 - pw / av_ppa[t])
        ga_ppa[t] += gt + rb - exp - cu - qd * max(0, gv_ppa[t] - av_ppa[t])

        # ppa lapse
        # itm = lapse_mult[1] * max(SINGLE_PREMIUM, av_ppa[t]) * gapv_gmdb_life_factor[t - 1]
        itm = lapse_mult[1] * gv_ppa[t] * gapv_gmdb_life_factor[t - 1]
        if av_ppa[t] > 0
            itm /= av_ppa[t]
        end
        if itm < 0.5
            if t <= 37
                qw = 1.0 - (1.0 - lapse_rate_ppa[1, 1]) ^ (1.0 / 12)
            else
                qw = 1.0 - (1.0 - lapse_rate_ppa[2, 1]) ^ (1.0 / 12)
            end
        elseif 3 <= ceil(itm * 4) <= 8
            if t <= 37
                qw = 1.0 - (1.0 - lapse_rate_ppa[1, Int(ceil(itm * 4)) - 1]) ^ (1.0 / 12)
            else
                qw = 1.0 - (1.0 - lapse_rate_ppa[2, Int(ceil(itm * 4)) - 1]) ^ (1.0 / 12)
            end
        else
            if t <= 37
                qw = 1.0 - (1.0 - lapse_rate_ppa[1, 8]) ^ (1.0 / 12)
            else
                qw = 1.0 - (1.0 - lapse_rate_ppa[2, 8]) ^ (1.0 / 12)
            end
        end
        lives_ppa[t] = lives_ppa[t - 1] * (1.0 - qd) * (1.0 - qw)
    end
    ga_al_sr = GeneralAccountAssetLiability(scen_num, return_array, lives_sr .* ga_sr, [0.0 0.0 0.0])
    acc_naer_plus1_sr = GeneralAccountAssetLiability(scen_num, return_array, zeros(MAX_LIAB_DUR), [0.2 0.3 0.5])
    ga_al_ppa = GeneralAccountAssetLiability(scen_num, return_array, lives_ppa .* ga_ppa, [0.0 0.0 0.0])
    acc_naer_plus1_ppa = GeneralAccountAssetLiability(scen_num, return_array, zeros(MAX_LIAB_DUR), [0.2 0.3 0.5])
    floored_pvad_sr = similar(ga_al_sr)
    unfloored_pvad_sr = similar(ga_al_sr)
    floored_pvad_ppa = similar(ga_al_ppa)
    for i in 1:ACC_PERIOD
        floored_pvad_sr[i] = max(-ga_al_sr[i] - lives_sr[12 * i + 1] * av_sr[12 * i + 1], 0.0) / acc_naer_plus1_sr[i]
        unfloored_pvad_sr[i] = (-ga_al_sr[i] - lives_sr[12 * i + 1] * av_sr[12 * i + 1]) / acc_naer_plus1_sr[i]
        floored_pvad_ppa[i] = max(-ga_al_ppa[i] - lives_ppa[12 * i + 1] * av_ppa[12 * i + 1], 0.0) / acc_naer_plus1_ppa[i]
    end
    if INITIAL_AV > 0.0
        floored_gpvad_sr[scen_num] = maximum(floored_pvad_sr[1:ACC_PERIOD]) + INITIAL_AV
        unfloored_gpvad_sr[scen_num] = maximum(unfloored_pvad_sr[1:ACC_PERIOD]) + INITIAL_AV
        floored_gpvad_ppa[scen_num] = maximum(floored_pvad_ppa[1:ACC_PERIOD]) + INITIAL_AV
    else
        floored_gpvad_sr[scen_num] = maximum(floored_pvad_sr[1:ACC_PERIOD]) + SINGLE_PREMIUM * (1.0 - POLICY_CHARGE) * (1.0 - GUARANTEE_CHARGE[cld(ISSUE_AGE, 5) - 8, GENDER])
        unfloored_gpvad_sr[scen_num] = maximum(unfloored_pvad_sr[1:ACC_PERIOD]) + SINGLE_PREMIUM * (1.0 - POLICY_CHARGE) * (1.0 - GUARANTEE_CHARGE[cld(ISSUE_AGE, 5) - 8, GENDER])
        floored_gpvad_ppa[scen_num] = maximum(floored_pvad_ppa[1:ACC_PERIOD]) + SINGLE_PREMIUM * (1.0 - POLICY_CHARGE) * (1.0 - GUARANTEE_CHARGE[cld(ISSUE_AGE, 5) - 8, GENDER])
    end
end

sort!(floored_gpvad_sr)
sort!(unfloored_gpvad_sr)
sort!(floored_gpvad_ppa)