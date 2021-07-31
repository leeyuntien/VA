

const MAX_RN_CF_LEN = 1320
const MAX_RN_SCEN_MONTH = 66 * 12
const MAX_RN_SCENARIO = 2000
const MAX_RW_CF_LEN = 120
const MAX_RW_SCENARIO = 2000
const MAX_RW_SCEN_MONTH = 100 * 12
const RW_EQUITY_BOND_RATIO = [0.7, 0.3]
const GUAR_CHARGE = 0.0 # 0.0 to get net guarantee charges, actual guarantee charges to get reserves
const ME_CHARGE = [0.0018 * 12, 0.0018 * 12, 0.0018 * 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
const ME_CHARGE_POLICY = 3 * 12
const INV_CHARGE = 0.0126
const REBATE_CHARGE = 0.006
const SURR_CHARGE = [0.05, 0.04, 0.02, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
const FRONT_CHARGE = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
const GDB_INC = [0, 0, 0.1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
const LAPSE_RATE = hcat([0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1],
        [0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02],
        [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5])
const PW_RATE = [0.0003, 0]
const MORT_PRIC = hcat([1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1])
const MORT_RESV = hcat([0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9],
        [0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9])
const MORT_EXP = hcat([0.3, 0.4125, 0.525, 0.6375, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75],
        [0.22, 0.3525, 0.485, 0.6175, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75, 0.75])
const AV_LEVEL = [0, 20, 10]
const SSA_LAPSE_RATE = hcat([0.05, 0.02, 0.02, 0.02], [0.1, 0.02, 0, 0])
const SSA_INIT_DROP_RATE = hcat([-0.135, 0, -0.081], [-0.2, 0, -0.12])
const SSA_RESERVE_RETURN_RATE = hcat([0, 0.04, 0.04, 0.04, 0.04, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055],
        [0, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485],
        [0, 0.0434, 0.0434, 0.0434, 0.0434, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524, 0.0524])
const SSA_CAPITAL_RETURN_RATE = hcat([0, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03],
        [0, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485, 0.0485],
        [0, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374, 0.0374])
const SSA_MARGIN = [0.0113, 0.0078, 0.0113 - 0.5 * max(0, INV_CHARGE - REBATE_CHARGE - 0.002 - max(0.002, GUAR_CHARGE)), 0.0078 - min(0.0065, 0.5 * max(0, INV_CHARGE - 0.001 - max(0.002, GUAR_CHARGE)))]
const TAX_RATE = [0.2, 0.17, 0.05]
const STAB_RATE = [0, 0.000002592, 0.0081]
const EXPENSES = [0.0005, (504.77 + 215.61) / 30, 0, 215.61 / 30, 0.0005, 0, 0.0176, 0, 0.000350592, 0.1581] # acq per premium, acq per policy, maint per asset, maint per policy, maint per premium, maint per GA reserve, inflation
const SURR_CHG_AMORT = 3

@enum Purpose begin
    Hedge_Cost = 1
    SSAReserve = 2
    SSACapital = 3
    CTEReserve = 4
    PM = 5
end

using CSV
using DataFrames
using DataStructures
using SharedArrays
using Base.Threads

# read risk neutral scenario file, 2000 scenarios of annualized return rates by month up to 66 years
RiskNeutralFile = "C:/Users/yuntien.lee/Documents/Work/VA/SKL/RN/30ETF_NoMMRS_Monthly/30ETF_NoMMRS_Monthly/3.csv"
risk_neutral_scenarios = DataFrame(CSV.File(RiskNeutralFile)) # scenario, timestep, TOTALRETURN

# read real world scenario file, 2000 scenarios of annualized return rates by month up to 100 years
RealWorldFile = "C:/Users/yuntien.lee/Documents/Work/VA/SKL/RW/ReturnScenario_2000.csv"
real_world_scenarios = DataFrame(CSV.File(RealWorldFile)) # Scenario, Month, EquityReturn, BondReturn

# mortality table file
MortalityTableFile = "C:/Users/Yuntien.Lee/Documents/Work/VA/jl/TSO2011.csv"
mortality_table = DataFrame(CSV.File(MortalityTableFile)) # Age, Male, Female

# read policy file
PolicyFile = "C:/Users/Yuntien.Lee/Documents/Work/VA/jl/SKL_policies.csv"
policies = DataFrame(CSV.File(PolicyFile)) # Gender, Issue Age, Deferred Period, Average Single Premium, Weight per Policy

# read discount file
DiscountFile = "C:/Users/Yuntien.Lee/Documents/Work/VA/jl/discount_rates.csv"
discount_rates = DataFrame(CSV.File(DiscountFile)) # forward rate, spot rate, SSA reserve rate, SSA capital rate, profit margin rate

# select purpose of program
purpose = CTEReserve

discounts = zeros(MAX_RN_CF_LEN + 1)
discounts[1] = 1
discounts_aft_tax = zeros(MAX_RW_CF_LEN + 1)
discounts_aft_tax[1] = 1
if purpose == Hedge_Cost
    for y in 1:size(discount_rates)[1]
        for m in 1:12
            t = 12 * (y  - 1) + m
            discounts[t + 1] = discounts[t] * (1 + discount_rates[y, 1]) ^ (1 / 12)
        end
    end
elseif purpose == SSAReserve
    for y in 1:size(discount_rates)[1]
        discounts[y + 1] = (1 + discount_rates[y, 3]) ^ y
    end
elseif purpose == SSACapital
    for y in 1:size(discount_rates)[1]
        discounts[y + 1] = (1 + discount_rates[y, 4]) ^ y
    end
elseif purpose == CTEReserve
    for y in 1:size(discount_rates)[1]
        discounts[y + 1] = (1 + discount_rates[y, 2]) ^ y
        discounts_aft_tax[y + 1] = (1 + discount_rates[y, 2] * (1  - TAX_RATE[1])) ^ y
    end
end

# loop through all policies
@inbounds for p in 1:1#size(policies)[1]
    if purpose == Hedge_Cost
        #=s = @distributed (+) for scen in 1:MAX_RN_SCENARIO
            # account value related
            account_values = zeros(MAX_RN_CF_LEN + 1) # balance items store values at BOP
            surrender_values = zeros(MAX_RN_CF_LEN + 1) # balance items store values at BOP
            premiums = zeros(MAX_RN_CF_LEN)
            benefits = zeros(MAX_RN_CF_LEN)
            maintenance_expenses = zeros(MAX_RN_CF_LEN)
            investment_incomes = zeros(MAX_RN_CF_LEN)
            partial_withdrawals = zeros(MAX_RN_CF_LEN)
            guarantee_levels = zeros(MAX_RN_CF_LEN + 1) # balance items store values at BOP
            guarantee_costs = zeros(MAX_RN_CF_LEN)
            guarantee_fees = zeros(MAX_RN_CF_LEN)
            premiums[1] = policies[p, 4] # average single premium
            initial_benefit = policies[p, 4] # average single premium
            guarantee_levels[1] = 1
            par_with_acc = 1
            pw_sum = 0
            @inbounds for y in 1:policies[p, 3] # deferred period
                for m in 1:12
                    t = 12 * (y - 1) + m
                    account_values[t + 1] = account_values[t] + premiums[t]
                    guarantee_fees[t] = account_values[t + 1] * GUAR_CHARGE / 12
                    maintenance_expenses[t] = min(account_values[t + 1] * ME_CHARGE[y] / 12 + ME_CHARGE_POLICY / 12, account_values[t + 1] - guarantee_fees[t])
                    account_values[t + 1] -= guarantee_fees[t] + maintenance_expenses[t]
                    investment_incomes[t] = account_values[t + 1] * (risk_neutral_scenarios[(scen - 1) * (MAX_RN_SCEN_MONTH + 1) + t + 1, 3] - INV_CHARGE / 12)
                    account_values[t + 1] += investment_incomes[t]
                    surrender_values[t + 1] = account_values[t + 1] * (1 - SURR_CHARGE[y])
                    if m == 1
                        guarantee_levels[t + 1] = guarantee_levels[t] * (1 + GDB_INC[y])
                    else
                        guarantee_levels[t + 1] = guarantee_levels[t]
                    end
                    if account_values[t] > 0
                        par_with_acc *= (1 - partial_withdrawals[t - 1] / account_values[t])
                    end
                    benefits[t] = initial_benefit * round(guarantee_levels[t + 1] * 100) / 100 * par_with_acc
                    guarantee_costs[t] = max(0, benefits[t] - account_values[t + 1])
                    partial_withdrawals[t] = account_values[t + 1] * PW_RATE[1]
                    account_values[t + 1] -= partial_withdrawals[t]
                    pw_sum += partial_withdrawals[t]
                end
            end

            # survival factor related
            px = zeros(MAX_RN_CF_LEN + 1)
            qq = zeros(MAX_RN_CF_LEN)
            qw = zeros(MAX_RN_CF_LEN)
            act_mort_rat = MORT_PRIC
            px[1] = 1
            @inbounds for y in 1:policies[p, 3] # deferred period
                if y == 1
                    for m in 1:11
                        t = 12 * (y - 1) + m
                        qq[t] = px[t] * (1 - (1 - mortality_table[policies[p, 2] + y, policies[p, 1] + 1] * act_mort_rat[y, policies[p, 1]]) ^ (1 / 12))
                        qw[t] = 0
                        px[t + 1] = px[t] - qq[t] - qw[t]
                    end
                    m = 12
                    t = 12 * (y - 1) + m
                    in_the_moneyness = 0
                    if benefits[t] > 0
                        in_the_moneyness = surrender_values[t + 1] / benefits[t]
                    end
                    convoluted_lapse = min(max(LAPSE_RATE[y, 2], LAPSE_RATE[y, 1] * in_the_moneyness ^ 3), LAPSE_RATE[y, 3]) # 1 = base, 2 = min, 3 = max
                    qq[t] = px[t] * (1 - (1 - mortality_table[policies[p, 2] + y, policies[p, 1] + 1] * act_mort_rat[y, policies[p, 1]]) ^ (1 / 12)) * (1 - convoluted_lapse / 2)
                    qw[t] = px[t] * convoluted_lapse * (1 - (1 - (1 - mortality_table[policies[p, 2] + 1, policies[p, 1] + 1] * act_mort_rat[y, policies[p, 1]]) ^ (1 / 12)) / 2)
                    px[t + 1] = px[t] - qq[t] - qw[t]
                    if account_values[t + 1] <= 0
                        qw[t] = px[t] - qq[t]
                        px[t + 1] = 0
                    end
                else
                    for m in 1:12
                        t = 12 * (y - 1) + m
                        in_the_moneyness = 0
                        if benefits[t] > 0
                            in_the_moneyness = surrender_values[t + 1] / benefits[t]
                        end
                        convoluted_lapse = min(max(LAPSE_RATE[y, 2], LAPSE_RATE[y, 1] * in_the_moneyness ^ 3), LAPSE_RATE[y, 3]) # 1 = base, 2 = min, 3 = max
                        qq[t] = px[t] * (1 - (1 - mortality_table[policies[p, 2] + y, policies[p, 1] + 1] * act_mort_rat[y, policies[p, 1]]) ^ (1 / 12)) * (1 - (1 - (1 - convoluted_lapse) ^ (1 / 12)) / 2)
                        qw[t] = px[t] * (1 - (1 - convoluted_lapse) ^ (1 / 12)) * (1 - (1 - (1 - mortality_table[policies[p, 2] + 1, policies[p, 1] + 1] * act_mort_rat[y, policies[p, 1]]) ^ (1 / 12)) / 2)
                        px[t + 1] = px[t] - qq[t] - qw[t]
                        if account_values[t + 1] <= 0
                            qw[t] = px[t] - qq[t]
                            px[t + 1] = 0
                        end
                    end
                end
            end

            # calculate guaratee cost
            #=@inbounds for t in 1:MAX_RN_CF_LEN
                if discounts[t + 1] > 0
                    sum_cf_nom += (guarantee_costs[t] * qq[t]) / discounts[t + 1]
                    sum_cf_den += (account_values[t + 1] * px[t] / 12) / discounts[t + 1]
                end
            end=#
            [sum(guarantee_costs[1:12*policies[p, 3]] .* qq[1:12*policies[p, 3]] ./ discounts[2:(12*policies[p, 3]+1)]),
            sum(account_values[2:(12*policies[p, 3]+1)] .* px[1:12*policies[p, 3]] ./ 12 ./ discounts[2:(12*policies[p, 3]+1)])]
        end
        @show p, s[1] / s[2]=#
    elseif purpose == SSAReserve || purpose == SSACapital || purpose == CTEReserve
        # res_table = zeros(policies[p, 3], AV_LEVEL[2] - AV_LEVEL[1] + 1)
        # cap_table = zeros(policies[p, 3], AV_LEVEL[2] - AV_LEVEL[1] + 1)
        # @time for av_level in range(AV_LEVEL[1], AV_LEVEL[2], step = 1)
            # for dur in 0:(policies[p, 3] - 1)
                res_by_scen = zeros(MAX_RW_SCENARIO * (AV_LEVEL[2] - AV_LEVEL[1] + 1) * policies[p, 3])
                cap_by_scen = zeros(MAX_RW_SCENARIO * (AV_LEVEL[2] - AV_LEVEL[1] + 1) * policies[p, 3])
                # @threads for scen in 1:(purpose == CTEReserve ? MAX_RW_SCENARIO : 1)
                @time @threads for allind in 1:((AV_LEVEL[2] - AV_LEVEL[1] + 1) * policies[p, 3] * MAX_RW_SCENARIO)
                    av_level = (allind - 1) ÷ (AV_LEVEL[2] - AV_LEVEL[1] + 1)
                    dur = (allind - 1) ÷ ((AV_LEVEL[2] - AV_LEVEL[1] + 1) * policies[p, 3])
                    scen = (allind - 1) % ((AV_LEVEL[2] - AV_LEVEL[1] + 1) * policies[p, 3]) + 1
                    # account value related
                    account_values = zeros(MAX_RW_CF_LEN + 1) # balance items store values at BOP
                    if purpose == CTEReserve
                        account_values[1] = max(policies[p, 4] * av_level / AV_LEVEL[3], 0.01) # allow precisions
                    elseif purpose == SSAReserve
                        account_values[1] = max(policies[p, 4] * av_level / AV_LEVEL[3], 0.01) * (1 + SSA_INIT_DROP_RATE[3, 1]) # allow precisions
                    else
                        account_values[1] = max(policies[p, 4] * av_level / AV_LEVEL[3], 0.01) * (1 + SSA_INIT_DROP_RATE[3, 2]) # allow precisions
                    end
                    account_values_in_month = zeros(12)
                    premiums = zeros(MAX_RN_CF_LEN)
                    premiums[1] = policies[p, 4]
                    benefits = zeros(MAX_RW_CF_LEN)
                    initial_benefit = policies[p, 4]
                    maintenance_expenses = zeros(MAX_RW_CF_LEN)
                    partial_withdrawals = zeros(MAX_RW_CF_LEN)
                    guarantee_levels = zeros(MAX_RW_CF_LEN + 1) # balance items store values at BOP
                    guarantee_levels[1] = 1
                    guarantee_costs = zeros(MAX_RW_CF_LEN)
                    par_with_acc = 1
                    for y in 1:dur
                        guarantee_levels[y + 1] = guarantee_levels[y] * (1 + GDB_INC[y])
                        par_with_acc *= (1 - PW_RATE[1]) ^ 12
                    end
                    partial_withdrawals[1] = account_values[1] * (1 - (1 - PW_RATE[1]) ^ (12 * dur))
                    pw_sum = partial_withdrawals[1]
                    for y in 1:(policies[p, 3] - dur)
                        account_values[y + 1] = account_values[y] + premiums[y + 1]
                        if purpose == SSAReserve || purpose == SSACapital
                            maintenance_expenses[y] = min(account_values[y + 1] * (GUAR_CHARGE + ME_CHARGE[y + dur]) + ME_CHARGE_POLICY * 12, account_values[y + 1])
                            account_values[y + 1] = (account_values[y] - maintenance_expenses[y]) * (SSA_RESERVE_RETURN_RATE[y + dur, 3] - INV_CHARGE)
                            guarantee_levels[y + dur + 1] = guarantee_levels[y + dur] * (1 + GDB_INC[y + dur])
                            if account_values[y] > 0
                                par_with_acc *= (1 - partial_withdrawals[y] / account_values[y])
                            end
                            benefits[y] = initial_benefit * round(guarantee_levels[y + dur + 1] * 100) / 100 * par_with_acc
                            guarantee_costs[y] = max(0, benefits[y] - account_values[y + 1])
                            partial_withdrawals[y] = account_values[y + 1] * (1 - (1 - PW_RATE[1] ^ 12))
                            pw_sum += partial_withdrawals[y]
                            account_values[y + 1] *= (1 - PW_RATE[1]) ^ 12
                        else
                            maintenance_expenses[y] = min(account_values[y + 1] * (GUAR_CHARGE + ME_CHARGE[y + dur]) / 12 + ME_CHARGE_POLICY, account_values[y + 1])
                            scen_idx = (scen - 1) * MAX_RW_SCEN_MONTH + 12 * (y + dur) - 11
                            account_values_in_month[1] = (account_values[y + 1] - maintenance_expenses[y]) * (real_world_scenarios[scen_idx, 3] * RW_EQUITY_BOND_RATIO[1] + real_world_scenarios[scen_idx, 4] * RW_EQUITY_BOND_RATIO[2] - INV_CHARGE / 12)
                            partial_withdrawals[y] = account_values_in_month[1] * PW_RATE[1]
                            account_values_in_month[1] *= (1 - PW_RATE[1])
                            for m in 2:12
                                add_exp = min(account_values_in_month[m - 1] * (GUAR_CHARGE + ME_CHARGE[y + dur]) / 12 + ME_CHARGE_POLICY, account_values_in_month[m - 1])
                                maintenance_expenses[y] += add_exp
                                scen_idx = (scen - 1) * MAX_RW_SCEN_MONTH + 12 * (y + dur) - 12 + m
                                account_values_in_month[m] = (account_values_in_month[m - 1] - add_exp) * (real_world_scenarios[scen_idx, 3] * RW_EQUITY_BOND_RATIO[1] + real_world_scenarios[scen_idx, 4] * RW_EQUITY_BOND_RATIO[2] - INV_CHARGE / 12)
                                if m == 7
                                    guarantee_levels[y + dur + 1] = guarantee_levels[y + dur] * (1 + GDB_INC[y + dur])
                                    if account_values[y] > 0
                                        par_with_acc *= (1 - partial_withdrawals[y] / account_values[y])
                                    end
                                    benefits[y] = initial_benefit * round(guarantee_levels[y + dur + 1] * 100) / 100 * par_with_acc
                                    guarantee_costs[y] = max(0, benefits[y] - account_values_in_month[m])
                                end
                                partial_withdrawals[y] += account_values_in_month[m] * PW_RATE[1]
                                account_values_in_month[m] *= (1 - PW_RATE[1])
                            end
                            pw_sum += partial_withdrawals[y]
                            account_values[y] = account_values_in_month[12]
                        end
                    end

                    # survival factor related
                    px = zeros(MAX_RW_CF_LEN + 1)
                    qq = zeros(MAX_RW_CF_LEN)
                    qw = zeros(MAX_RW_CF_LEN)
                    act_mort_rat = MORT_RESV
                    px[1] = 1
                    if purpose == SSAReserve || purpose == SSACapital
                        for y in 1:(policies[p, 3] - dur)
                            if account_values[y + 1] <= 0
                                convoluted_lapse = SSA_LAPSE_RATE[4, SURR_CHARGE[y + dur] > 0 ? 1 : 2]
                            else
                                in_the_moneyness = 0
                                if account_values[y + 1] > 0
                                    in_the_moneyness = benefits[y] / account_values[y + 1] - 1
                                end
                                if in_the_moneyness <= 0
                                    convoluted_lapse = SSA_LAPSE_RATE[1, SURR_CHARGE[y + dur] > 0 ? 1 : 2]
                                elseif in_the_moneyness < 0.1
                                    convoluted_lapse = SSA_LAPSE_RATE[2, SURR_CHARGE[y + dur] > 0 ? 1 : 2]
                                elseif in_the_moneyness < 0.2
                                    convoluted_lapse = SSA_LAPSE_RATE[3, SURR_CHARGE[y + dur] > 0 ? 1 : 2]
                                else
                                    convoluted_lapse = SSA_LAPSE_RATE[4, SURR_CHARGE[y + dur] > 0 ? 1 : 2]
                                end
                                qq[y] = px[y] * mortality_table[policies[p, 2] + y + dur, policies[p, 1] + 1] * act_mort_rat[y + dur, policies[p, 1]] * (1 - convoluted_lapse / 2)
                                qw[y] = px[y] * convoluted_lapse * (1 - mortality_table[policies[p, 2] + y + dur, policies[p, 1] + 1] * act_mort_rat[y + dur, policies[p, 1]] / 2)
                                px[y + 1] = px[y] - qq[y] - qw[y]
                            end
                        end
                    else
                        for y in 1:(policies[p, 3] - dur)
                            in_the_moneyness = 0
                            if benefits[y] > 0
                                in_the_moneyness = account_values[y + 1] * (1 - SURR_CHARGE[y]) / benefits[y]
                            end
                            convoluted_lapse = min(max(LAPSE_RATE[y + dur, 2], LAPSE_RATE[y + dur, 1] * in_the_moneyness ^ 3), LAPSE_RATE[y + dur, 3]) # 1 = base, 2 = min, 3 = max
                            qq[y] = px[y] * mortality_table[policies[p, 2] + y + dur, policies[p, 1] + 1] * act_mort_rat[y + dur, policies[p, 1]] * (1 - convoluted_lapse / 2)
                            qw[y] = px[y] * convoluted_lapse * (1 - mortality_table[policies[p, 2] + y + dur, policies[p, 1] + 1] * act_mort_rat[y + dur, policies[p, 1]] / 2)
                            px[y + 1] = px[y] - qq[y] - qw[y]
                        end
                    end

                    # calculate reserve
                    gpv_res = 0
                    gpv_cap = 0
                    if purpose == SSAReserve
                        cur = 0
                        for y in 1:(policies[p, 3] - dur)
                            cf = guarantee_costs[y] * qq[y]
                            if y <= SURR_CHG_AMORT - dur
                                cf -= SSA_MARGIN[3] * account_values[y + 1] * px[y + 1]
                            else
                                cf -= px[y + 1] * (SSA_MARGIN[1] * account_values[y + 1] + 0.5 * ME_CHARGE_POLICY * 12)
                            end
                            cur = cur * (1 + discount_rates[y, 1]) ^ y + cf
                            gpv_res = max(gpv_res, cur / discounts[y + dur] * discounts[dur + 1])
                        end
                    elseif purpose == SSACapital
                        cur = 0
                        for y in 1:(policies[p, 3] - dur)
                            cf = guarantee_costs[y] * qq[y]
                            if y <= SURR_CHG_AMORT - dur
                                cf -= SSA_MARGIN[4] * account_values[y + 1] * px[y + 1]
                            else
                                cf -= px[y + 1] * (SSA_MARGIN[2] * account_values[y + 1] + 0.5 * ME_CHARGE_POLICY * 12)
                            end
                            cur = cur * (1 + discount_rates[y, 1]) ^ y * (1 - TAX_RATE[1]) + cf * (1 - TAX_RATE[1])
                            gpv_cap = max(gpv_cap, cur / discounts[y + dur] * discounts[dur + 1])
                        end
                    else
                        cur_res = 0
                        cur_cap = 0
                        for y in 1:(policies[p, 3] - dur)
                            cf = px[y] * premiums[y] * FRONT_CHARGE[y];
                            cf += px[y] * maintenance_expenses[y];
                            cf += account_values[y + 1] * SURR_CHARGE[y] * (1 - TAX_RATE[3]) * qw[y];
                            cf += partial_withdrawals[y] * SURR_CHARGE[y] * (1 - TAX_RATE[3]);
                            cf += REBATE_CHARGE * account_values[y + 1] * px[y + 1];
                            if y == 1 && dur == 0
                                cf -= px[1] * premiums[1] * EXPENSES[1] + px[1] * EXPENSES[2] + px[1] * account_values[1] * EXPENSES[3]
                            else
                                cf -= px[y] * account_values[y] * EXPENSES[3] + px[y] * EXPENSES[4] * (1 + EXPENSES[7]) ^ (y + dur - 1)
                            end;
                            cf -= px[y] * premiums[y] * EXPENSES[5];
                            cf -= EXPENSES[6];
                            if (EXPENSES[8] - STAB_RATE[1]) * px[y] * premiums[y] + (EXPENSES[9] - STAB_RATE[2]) * px[y] * account_values[y] + (EXPENSES[10] - STAB_RATE[3]) * px[y] < 0
                                cf -= STAB_RATE[1] * px[y] * premiums[y] + STAB_RATE[2] * px[y] * account_values[y] + STAB_RATE[3] * 12 * px[y]
                            else
                                cf -= EXPENSES[8] * px[y] * premiums[y] + (EXPENSES[9] + ME_CHARGE[y + dur] * 0.0527) * px[y] * account_values[y] + EXPENSES[10] * 12 * px[y]
                            end;
                            cf -= guarantee_costs[y] * qq[y];
                            cur_res = cur_res * (1 + discount_rates[y + dur, 1]) + cf * (1 + discount_rates[y + dur, 1]) ^ 0.5
                            cur_cap = cur_cap * (1 + discount_rates[y + dur, 1]) + cf * (1 - TAX_RATE[1]) * (1 + discount_rates[y + dur, 1]) ^ 0.5
                            gpv_res = min(gpv_res, cur_res / discounts[y + dur + 1] * discounts[dur + 1])
                            gpv_cap = min(gpv_cap, cur_cap / discounts_aft_tax[y + dur + 1] * discounts[dur + 1])
                        end
                        gpv_res *= -1
                        gpv_cap *= -1
                    end
                    # res_by_scen[scen] = gpv_res / policies[p, 4]
                    res_by_scen[allind] = gpv_res / policies[p, 4]
                    # cap_by_scen[scen] = gpv_cap / policies[p, 4]
                    cap_by_scen[allind] = gpv_cap / policies[p, 4]
                end
                if purpose == CTEReserve
                    # sort!(res_by_scen)
                    # sort!(cap_by_scen)
                    #@show av_level, dur + 1, sum(res_by_scen[Int(0.7 * MAX_RW_SCENARIO):end]) / (Int(0.3 * MAX_RW_SCENARIO)), sum(cap_by_scen[Int(0.9 * MAX_RW_SCENARIO):end]) / (Int(0.1 * MAX_RW_SCENARIO))
                    for allind in 1:((AV_LEVEL[2] - AV_LEVEL[1] + 1) * policies[p, 3])
                        r = sort(res_by_scen[((allind - 1) * MAX_RW_SCENARIO + 1) : allind * MAX_RW_SCENARIO])
                        c = sort(cap_by_scen[((allind - 1) * MAX_RW_SCENARIO + 1) : allind * MAX_RW_SCENARIO])
                        #@show (allind - 1) ÷ (AV_LEVEL[2] - AV_LEVEL[1] + 1), (allind - 1) % (AV_LEVEL[2] - AV_LEVEL[1] + 1) + 1, sum(r[Int(0.7 * MAX_RW_SCENARIO):end]) / (Int(0.3 * MAX_RW_SCENARIO)), sum(c[Int(0.9 * MAX_RW_SCENARIO):end]) / (Int(0.1 * MAX_RW_SCENARIO))
                    end
                else
                    #@show av_level, dur + 1, res_by_scen, cap_by_scen
                    for allind in 1:((AV_LEVEL[2] - AV_LEVEL[1] + 1) * policies[p, 3])
                        r = sort(res_by_scen[((allind - 1) * MAX_RW_SCENARIO + 1) : allind * MAX_RW_SCENARIO])
                        c = sort(cap_by_scen[((allind - 1) * MAX_RW_SCENARIO + 1) : allind * MAX_RW_SCENARIO])
                        #@show (allind - 1) ÷ (AV_LEVEL[2] - AV_LEVEL[1] + 1), (allind - 1) % (AV_LEVEL[2] - AV_LEVEL[1] + 1) + 1, r, c
                    end
                end
            # end
        # end
    elseif purpose == PM
        0.08 * 0.3 + 0.04 * 0.7 # equity 30% with return 8%, bond 70% with return 4%
    end
end
