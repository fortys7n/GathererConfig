local Tinkr = ...
C_Timer.After(5, function()
local JSON = Tinkr.Util.JSON
local ObjectManager = Tinkr.Util.ObjectManager
local Fly = Tinkr.Util.Fly
local Draw = Tinkr.Util.Draw:New()
local AceGUI = Tinkr.Util.AceGUI
local height = ObjectHeight('player')
local Evaluator = Tinkr.Util.Evaluator
local LastTime = GetTime() 
local LastAngTime = GetTime()
local Lastloot = GetTime()
local Chiltime = nil
local crash = false
local Lootobj = nil
local hx,hy,hz,xfp,yfp,zfp,rfp
local px, py, pz = ObjectPosition("player")
local path
local Unstuck = true
local Flee = false
local Bunker = false
local Blacklist = {}
local SpeedyLootTableRow = {}
local SpeedyLootTable = {}
local HitsLa = {}
local HitsLb = {}
local LastPoint
local lastguid
local NextPoint
local BlacklistedPlace = {}
local Liste = {}
local AutoBlacklistedPlace = {}
local LandBlacklistedPlace = {}
local WhitelistedPlace = {}
local Points = {}
local RescuePoints = {}
local RescLogging = true
local pathIndex
local Druid = false
local tarobject = nil
local Lootdistance = nil
local LoadUi = nil
local Stayonground = nil
local SpotFile
local Spot
local Map
local Status = "PAUSE"
local State = "PAUSE"
local LoadRoute
local LoadExpansion
local Mobrange = 0
local INTERRUPTED = 0
local GLIDING = false
local Vigor = C_UIWidgetManager.GetFillUpFramesWidgetVisualizationInfo(4460).numFullFrames
local Class = select(2, GetPlayerInfoByGUID(UnitGUID("player")))
local freeze = 0
local Resurrections = 0
local DeadmanTimer
local AvoidMove = false
local CanOverloadMining = false
local CanOverloadDFMining = false
local CanOverloadHerb = false
local CanOverloadDFHerb = false
skok = nil
SearchSplitt = false
local CanDuplicateHerb = false
local BumTime = GetTime()
local OverHerbExpTime = GetTime()
local NodeID
local TimeToSendMail
local TimeToUseGB
local Mailbox
BountHarv = true
Botan = false
OverUnder = false
Plethora = true
MiningFund = false
MastMyst = false
TWWHProfTreeSteps = {}
TWWMProfTreeSteps = {}
DefTWWHProfTreeSteps = {"Botany","Botany","Botany","Botany","Botany","Botany","Botany","Botany","Bountiful Harvests",
"Spear Scavenger","Spear Scavenger","Spear Scavenger","Spear Scavenger","Spear Scavenger","Spear Scavenger",
"Spear Scavenger","Spear Scavenger","Bountiful Harvests","Bountiful Harvests","Fungus Forager","Fungus Forager",
"Fungus Forager","Fungus Forager","Fungus Forager","Fungus Forager","Fungus Forager","Fungus Forager",
"Bountiful Harvests","Bountiful Harvests","Blossom Browser","Blossom Browser","Blossom Browser","Blossom Browser",
"Blossom Browser","Blossom Browser","Blossom Browser","Blossom Browser","Bountiful Harvests","Bountiful Harvests",
"Bountiful Harvests","Mulching","Mulching","Mulching","Mulching","Mulching","Mulching","Mulching","Mulching","Cultivation",
"Cultivation","Cultivation","Cultivation","Cultivation","Cultivation","Cultivation","Cultivation",
"Overloading the Underground","Irradiated","Irradiated","Irradiated","Irradiated","Irradiated","Irradiated",
"Irradiated","Irradiated","Overloading the Underground","Overloading the Underground","Overloading the Underground",
"Overloading the Underground","Overloading the Underground","Overloading the Underground","Overloading the Underground",
"Crystallized","Crystallized","Crystallized","Crystallized","Crystallized","Crystallized","Crystallized","Crystallized",
"Carnivorous Connoisseur","Carnivorous Connoisseur","Carnivorous Connoisseur","Carnivorous Connoisseur",
"Carnivorous Connoisseur","Carnivorous Connoisseur","Carnivorous Connoisseur","Carnivorous Connoisseur",
"Orbinid Observer","Orbinid Observer","Orbinid Observer","Orbinid Observer","Orbinid Observer","Orbinid Observer",
"Orbinid Observer","Orbinid Observer","Altered","Altered","Altered","Altered","Altered","Altered","Altered","Altered",
"Sporefused","Sporefused","Sporefused","Sporefused","Sporefused","Sporefused","Sporefused","Sporefused"}
DefTWWMProfTreeSteps = {"Mining Fundamentals","Mining Fundamentals","Mining Fundamentals","Mining Fundamentals",
"Mining Fundamentals","Mining Fundamentals","Mining Fundamentals","Mining Fundamentals","Mining Fundamentals",
"Mining Fundamentals","Mining Fundamentals","Mining Fundamentals","Plethora of Ore","Plethora of Ore","Bismuth",
"Bismuth","Bismuth","Bismuth","Bismuth","Bismuth","Bismuth","Bismuth","Bismuth","Plethora of Ore","Plethora of Ore",
"Plethora of Ore","Ironclaw","Ironclaw","Ironclaw","Ironclaw","Ironclaw","Ironclaw","Ironclaw","Ironclaw","Ironclaw",
"Plethora of Ore","Plethora of Ore","Plethora of Ore","Aqirite","Aqirite","Aqirite","Aqirite","Aqirite","Aqirite",
"Aqirite","Aqirite","Aqirite","Plethora of Ore","Plethora of Ore","Mastering the Mysterious","Mastering the Mysterious",
"Mastering the Mysterious","Mastering the Mysterious","Mastering the Mysterious","Mastering the Mysterious",
"Mastering the Mysterious","Mastering the Mysterious","Mastering the Mysterious","Outlawed Techniques",
"Outlawed Techniques","Outlawed Techniques","Outlawed Techniques","Outlawed Techniques","Outlawed Techniques",
"Outlawed Techniques","Outlawed Techniques","Rich Deposit","Rich Deposit","Rich Deposit","Rich Deposit","Rich Deposit",
"Webbed","Webbed","Webbed","Webbed","Webbed","Webbed","Webbed","Webbed","Crystallized",
"Crystallized","Crystallized","Crystallized","Crystallized","Crystallized","Crystallized","Crystallized","Weeping",
"Weeping","Weeping","Weeping","Weeping","Weeping","Weeping","Weeping","Seams","Seams","Seams","Seams","Seams"}
BountHarTree = true
BotanTree = true
OverUnderTree = true
PlethoraTree = true
MiningFundTree = true
MastMystTree = true
BountHarPoint = 0
BlossBroPoint = 0
CarConPoint = 0
FunFoPoint = 0
OrbObsPoint = 0
SpearScaPoint = 0
BotanPoint = 0
CultivPoint = 0
MulchPoint = 0
OverUnderPoint = 0
CrystallPoint = 0
MCrystallPoint = 0
AlteredPoint = 0
SporefusPoint = 0
IrradiaPoint = 0
PlethoraPoint = 0
BismuthPoint = 0
AqiritePoint = 0
IronclawPoint = 0
MiningFundPoint = 0
RichDepPoint = 0
SeamsPoint = 0
MastMystPoint = 0
WeepingPoint = 0
OutlawedPoint = 0
WebbedPoint = 0
MailboxStore ={{2552,963.34027099609,-1919.5972900391,81.568138122559},
{2552,3551.2473144531,-3351.7360839844,200.20028686523},
{2601,2276.8957519531,-2771.5329589844,415.65939331055},
{2601,1597.7396240234,-3814.5383300781,255.32307434082},
{2601,750.02954101562,-3588.7102050781,174.14476013184},
{2601,685.96875,-1574.3836669922,-987.46472167969},
{2601,-1491.4461669922,-615.61804199219,-1358.0561523438},
{2601,-2107.8386230469,-1000.2794799805,-1325.3403320312},
{2601,-1320.2326660156,-2860.6337890625,-1185.3540039062},
{2601,1861.2170410156,871.28472900391,126.9525680542},
{2601,1579.8541259766,34.098957061768,-56.810127258301},
{2601,1790.1110839844,-1458.2725830078,-150.26910400391},
{2601,2427.0051269531,-1327.7708740234,-46.2942237854},
{2601,2732.6267089844,323.875,64.421112060547}}
HSStore ={
	{HSMAP = 2552,	HSPOINTS = {
		{3582.0002441406,-3328.0756835938,195.18760681152},
		{3578.3928222656,-3331.6291503906,195.33312988281},
		{3574.4765625,-3335.5009765625,195.89064025879},
		{3571.0805664062,-3338.6108398438,198.63569641113},
		{3567.779296875,-3341.8083496094,200.91160583496},
		{3563.7890625,-3345.61328125,200.78907775879},
		{3559.859375,-3349.4938964844,200.9115447998},
		{3555.736328125,-3353.1538085938,200.25775146484},
		{3551.9262695312,-3356.4997558594,200.29579162598}
		}
	},
	{HSMAP = 2552,	HSPOINTS = {
		{2647.4489746094,-2473.4838867188,224.21380615234},
		{2644.6284179688,-2477.9016113281,224.08012390137},
		{2640.8334960938,-2481.53515625,224.32588195801},
		{2636.6850585938,-2485.2526855469,224.5065612793},
		{2632.6271972656,-2488.9985351562,224.33122253418},
		{2628.2180175781,-2493.1228027344,224.03231811523},
		{2624.5405273438,-2496.6030273438,224.03231811523},
		{2620.8666992188,-2500.0756835938,224.03231811523},
		{2618.7138671875,-2502.1105957031,224.03231811523}
		}
	},
	{HSMAP = 2552,	HSPOINTS = {
		{913.13616943359,-1919.1550292969,75.514862060547},
		{908.97827148438,-1916.2537841797,75.448051452637},
		{907.42315673828,-1910.66015625,75.531387329102},
		{908.54296875,-1905.1514892578,75.448684692383},
		{912.70825195312,-1901.7794189453,75.592346191406},
		{917.31884765625,-1898.7546386719,76.162414550781},
		{922.49200439453,-1899.8928222656,76.51921081543},
		{926.52856445312,-1902.7966308594,79.467102050781},
		{930.01031494141,-1905.7976074219,81.881248474121},
		{934.19329833984,-1909.4029541016,81.858901977539},
		{938.53948974609,-1913.1490478516,81.863945007324},
		{944.1201171875,-1914.5411376953,82.242286682129},
		{949.60919189453,-1914.9763183594,82.372947692871},
		{955.11419677734,-1915.4127197266,82.212509155273},
		{960.61114501953,-1915.8485107422,81.678215026855},
		{966.13220214844,-1916.2862548828,81.378845214844},
		{971.62115478516,-1916.7214355469,80.654457092285},
		{971.83782958984,-1916.7386474609,80.615829467773}
		}
	},
	{HSMAP = 2601,	HSPOINTS = {
		{2283.4057617188,-2807.9533691406,422.23425292969},
		{2283.6105957031,-2802.2033691406,422.10412597656},
		{2283.7863769531,-2796.68359375,422.33239746094},
		{2283.9206542969,-2791.1640625,422.52789306641},
		{2283.9050292969,-2785.6337890625,422.35424804688},
		{2283.9262695312,-2780.1276855469,420.61444091797},
		{2283.9177246094,-2775.53125,417.90908813477},
		{2283.8942871094,-2770.8220214844,415.55102539062},
		{2283.7702636719,-2765.2448730469,415.55102539062},
		{2283.4133300781,-2759.677734375,415.55102539062},
		{2283.3833007812,-2759.2280273438,415.55102539062}
		}
	},
	{HSMAP = 2601,	HSPOINTS = {
		{1608.6535644531,-3807.5859375,255.98452758789},
		{1603.1359863281,-3807.9577636719,256.05859375},
		{1597.6356201172,-3808.2124023438,255.69256591797},
		{1592.1213378906,-3808.5056152344,254.75268554688},
		{1586.6127929688,-3808.8955078125,254.1467590332},
		{1581.1134033203,-3809.2990722656,254.0412902832},
		{1578.3599853516,-3809.5053710938,254.0412902832}
		}
	},
	{HSMAP = 2601,	HSPOINTS = {
		{749.03125,-3607.6040039062,175.59780883789},
		{743.96258544922,-3605.1845703125,174.62391662598},
		{742.20977783203,-3599.828125,174.90151977539},
		{741.20330810547,-3594.3901367188,174.91297912598},
		{740.19982910156,-3588.9680175781,174.60458374023},
		{739.193359375,-3583.5300292969,173.99351501465},
		{738.18988037109,-3578.1079101562,173.89984130859},
		{737.85589599609,-3576.3032226562,173.88056945801}
		}
	},
	{HSMAP = 2601,	HSPOINTS = {
		{37.961364746094,-3923.8684082031,121.67213439941},
		{43.454181671143,-3923.4038085938,121.67213439941},
		{48.920146942139,-3923.921875,121.67052459717},
		{54.410873413086,-3923.3322753906,122.37373352051},
		{59.895023345947,-3922.7434082031,123.2770690918},
		{65.019538879395,-3921.9074707031,124.97044372559},
		{70.499137878418,-3921.3188476562,125.74960327148},
		{71.867813110352,-3921.1721191406,125.73084259033}
		}
	},
	{HSMAP = 2601,	HSPOINTS = {
		{686.15356445312,-1583.7852783203,-987.40295410156},
		{681.02575683594,-1584.3800048828,-987.60321044922},
		{676.76416015625,-1584.8658447266,-988.08508300781}
		}
	},
	{HSMAP = 2601,	HSPOINTS = {
		{-232.66436767578,-1448.4470214844,-1087.9017333984},
		{-235.34805297852,-1452.8448486328,-1088.1201171875},
		{-238.22044372559,-1457.5518798828,-1088.1201171875},
		{-241.72077941895,-1453.09375,-1088.1201171875},
		{-244.97981262207,-1448.6257324219,-1088.1201171875},
		{-248.22937011719,-1444.1707763672,-1088.0589599609},
		{-251.48365783691,-1439.7092285156,-1085.9588623047},
		{-255.49668884277,-1435.5510253906,-1085.9671630859},
		{-260.72518920898,-1433.7487792969,-1086.0277099609},
		{-265.96887207031,-1431.94140625,-1086.0277099609},
		{-271.18975830078,-1430.1418457031,-1085.9770507812},
		{-276.40301513672,-1428.3448486328,-1086.0137939453},
		{-281.62387084961,-1426.5452880859,-1085.0653076172},
		{-286.84475708008,-1424.7457275391,-1085.0147705078},
		{-292.05801391602,-1422.9487304688,-1085.1392822266},
		{-297.27886962891,-1421.1491699219,-1084.9498291016},
		{-302.62152099609,-1419.3076171875,-1086.3481445312},
		{-307.39337158203,-1417.6628417969,-1087.4323730469},
		{-312.62692260742,-1415.8588867188,-1087.5067138672},
		{-317.84777832031,-1414.0593261719,-1087.5067138672},
		{-323.06866455078,-1412.259765625,-1087.5067138672},
		{-328.28189086914,-1410.4627685547,-1087.5067138672},
		{-328.70809936523,-1410.3157958984,-1087.5067138672}
		}
	},
	{HSMAP = 2601,	HSPOINTS = {
		{-1337.4569091797,-2886.0747070312,-1185.6254882812},
		{-1340.2495117188,-2881.2827148438,-1185.6254882812},
		{-1342.90234375,-2876.7072753906,-1185.6254882812},
		{-1347.0140380859,-2873.4814453125,-1185.6254882812},
		{-1351.8371582031,-2870.79296875,-1185.6254882812},
		{-1356.2395019531,-2867.8999023438,-1184.8751220703},
		{-1360.0455322266,-2863.9204101562,-1184.6204833984},
		{-1363.4018554688,-2859.5151367188,-1184.802734375},
		{-1366.8245849609,-2855.1506347656,-1185.8602294922},
		{-1370.2719726562,-2850.8369140625,-1186.7159423828},
		{-1373.8361816406,-2846.619140625,-1186.9848632812},
		{-1377.224609375,-2842.2526855469,-1186.3720703125},
		{-1379.8355712891,-2838.1967773438,-1184.6427001953},
		{-1382.4997558594,-2833.6284179688,-1183.36328125},
		{-1385.4807128906,-2828.9865722656,-1182.1633300781},
		{-1389.193359375,-2824.8935546875,-1181.2456054688},
		{-1393.8166503906,-2821.9624023438,-1180.6947021484},
		{-1398.9467773438,-2819.9833984375,-1180.4821777344},
		{-1404.3603515625,-2818.853515625,-1180.6315917969},
		{-1409.6055908203,-2817.1997070312,-1181.0047607422},
		{-1413.8612060547,-2813.8090820312,-1180.4995117188},
		{-1415.8861083984,-2808.9289550781,-1179.4923095703},
		{-1416.8753662109,-2806.3598632812,-1178.6724853516}
		}
	},
	{HSMAP = 2601,	HSPOINTS = {
		{-1498.6545410156,-611.21813964844,-1357.9664306641},
		{-1504.1745605469,-612.14416503906,-1358.0969238281}
		}
	},
	{HSMAP = 2601,	HSPOINTS = {
		{-1784.1610107422,-884.09942626953,-1242.5111083984},
		{-1784.0484619141,-889.62866210938,-1242.5515136719},
		{-1783.9360351562,-895.14978027344,-1242.5432128906},
		{-1783.8237304688,-900.67095947266,-1242.5515136719},
		{-1783.7111816406,-906.2001953125,-1242.5515136719},
		{-1783.5977783203,-911.76959228516,-1242.5515136719},
		{-1783.4852294922,-917.298828125,-1242.1525878906},
		{-1783.3682861328,-923.04534912109,-1242.755859375},
		{-1783.255859375,-928.56652832031,-1244.6439208984},
		{-1783.1435546875,-934.08764648438,-1244.6358642578},
		{-1783.0296630859,-939.68127441406,-1244.4865722656},
		{-1782.9689941406,-942.6591796875,-1244.3934326172}
		}
	},
	{HSMAP = 2601,	HSPOINTS = {
		{-2109.9897460938,-1140.115234375,-1244.1593017578},
		{-2108.5612792969,-1145.2662353516,-1244.2133789062},
		{-2107.080078125,-1150.6363525391,-1244.2133789062},
		{-2105.5517578125,-1156.1771240234,-1244.2133789062},
		{-2104.0832519531,-1161.5007324219,-1243.7716064453},
		{-2102.7062988281,-1166.4925537109,-1243.6257324219},
		{-2101.2229003906,-1171.8704833984,-1243.7817382812},
		{-2099.7329101562,-1177.2716064453,-1244.2142333984},
		{-2098.0825195312,-1183.2543945312,-1244.2142333984},
		{-2097.0122070312,-1187.1348876953,-1244.2142333984}
		}
	},
	{HSMAP = 2601,	HSPOINTS = {
		{-2068.30859375,-1050.4055175781,-1325.7978515625},
		{-2071.3896484375,-1046.9293212891,-1323.6984863281},
		{-2074.8181152344,-1043.2320556641,-1323.6364746094},
		{-2078.2536621094,-1039.4815673828,-1323.767578125},
		{-2081.8520507812,-1035.6617431641,-1323.767578125},
		{-2085.37109375,-1031.9284667969,-1323.7160644531},
		{-2089.1118164062,-1027.9598388672,-1323.7674560547},
		{-2092.6420898438,-1024.2370605469,-1323.4691162109},
		{-2096.2263183594,-1020.4644775391,-1322.6967773438},
		{-2099.7309570312,-1016.8190307617,-1322.7612304688},
		{-2103.4438476562,-1013.0039672852,-1322.7821044922},
		{-2108.1604003906,-1008.5147094727,-1323.2806396484},
		{-2111.8823242188,-1005.0694580078,-1325.08984375},
		{-2115.6154785156,-1001.6585083008,-1325.1016845703},
		{-2119.4135742188,-998.22491455078,-1325.4855957031},
		{-2123.3212890625,-994.8564453125,-1325.4699707031},
		{-2125.5285644531,-992.93768310547,-1325.4665527344}
		}
	},
	{HSMAP = 2601,	HSPOINTS = {
		{1168.7506103516,1022.8464355469,40.36209487915},
		{1163.9566650391,1020.8917236328,40.36209487915},
		{1159.1632080078,1019.0169067383,40.348880767822},
		{1154.1828613281,1017.9022216797,40.352561950684},
		{1152.0460205078,1017.9366455078,40.344348907471}
		}
	},
	{HSMAP = 2601,	HSPOINTS = {
		{1850.3663330078,850.0458984375,127.64992523193},
		{1854.6033935547,853.77294921875,127.63080596924},
		{1855.4075927734,858.75048828125,127.63083648682},
		{1856.1005859375,864.02264404297,127.62586212158},
		{1856.8216552734,869.50579833984,127.63498687744},
		{1857.5506591797,875.05017089844,126.95193481445},
		{1860.0563964844,879.61340332031,127.00171661377},
		{1864.9526367188,882.14978027344,126.95346832275},
		{1868.2479248047,883.85675048828,126.95346832275}
		}
	},
	{HSMAP = 2601,	HSPOINTS = {
		{2751.5949707031,317.33456420898,64.442123413086},
		{2746.8891601562,319.20391845703,64.424362182617},
		{2741.8415527344,319.6042175293,64.424423217773},
		{2736.4660644531,319.92916870117,64.419929504395},
		{2731.0456542969,320.39358520508,64.430267333984},
		{2725.5854492188,321.21746826172,63.78910446167},
		{2720.1025390625,322.19985961914,63.442562103271},
		{2715.4892578125,324.86557006836,63.278297424316},
		{2711.482421875,328.65411376953,63.739753723145},
		{2707.4699707031,332.46026611328,63.084999084473},
		{2705.3010253906,334.51760864258,62.277015686035}
		}
	},
	{HSMAP = 2601,	HSPOINTS = {
		{2414.7065429688,-1342.8839111328,-45.335674285889},
		{2414.2189941406,-1337.4056396484,-45.291828155518},
		{2416.8889160156,-1333.1079101562,-45.335708618164},
		{2420.3962402344,-1328.80078125,-45.361122131348},
		{2423.6364746094,-1324.9102783203,-46.351245880127},
		{2427.3557128906,-1321.1390380859,-46.464000701904},
		{2431.3032226562,-1317.2806396484,-46.772735595703},
		{2435.4750976562,-1313.5533447266,-47.072250366211},
		{2439.4484863281,-1309.7312011719,-46.987754821777},
		{2443.1853027344,-1305.6661376953,-49.369945526123},
		{2446.255859375,-1302.2457275391,-52.230010986328},
		{2449.9448242188,-1298.1363525391,-53.420852661133},
		{2453.6875,-1293.9671630859,-53.420852661133},
		{2457.4831542969,-1289.6942138672,-53.420852661133},
		{2458.8627929688,-1288.1203613281,-53.420852661133}
		}
	},
	{HSMAP = 2454,	HSPOINTS = {
		{376, 3889, 76},
		{377, 3899, 76},
		{312, 3857, 74}
		}
	}
}
local mx,my,mz 
local count = 0
NeedFlaskAndItemUse = nil
IgnObj = {}
PrioObj = {}
items = { 
  224752, --Soaked Journal Entry
  194062, --Unyielding Stone Chunk
  194039, --Heated Ore Sample
  200678, --Dreambloom
  200677, --Dreambloom Petal
  201300, --Iridescent Ore Fragments
  201301, --Iridescent Ore
  202011, --Elementally Charged Stone
  202014, --Infused Pollen
  204911, --Propagated Spore
  224583, --Slab of Slate  
  224838, --Null Sliver
  224264, --Deepgrove Petal
  224835, --Deepgrove Roots
  224584, --Erosion-Polished Slate
  224265, --Deepgrove Rose
  224818, --Algari Miner's Notes
  224817, --Algari Herbalist's Notes
  124671, -- Darkmoon Firewater
  212308, -- Phial of Truesight 1
  212309, -- Phial of Truesight 2
  212310, -- Phial of Truesight 3
  212314, -- Phial of Bountiful Seasons 1
  212315, -- Phial of Bountiful Seasons 2
  212316, -- Phial of Bountiful Seasons 3
  222505, -- Ironclaw Razorstone 1
  222506, -- Ironclaw Razorstone 2
  222507, -- Ironclaw Razorstone 3
  191948, -- Primal Razorstone 1
  191949, -- Primal Razorstone 2
  191950, -- Primal Razorstone 3  
  191342, -- Aerated Phial of Deftness 1
  191343, -- Aerated Phial of Deftness 2
  191344, -- Aerated Phial of Deftness 3
  191345, -- Steaming Phial of Finesse 1
  191346, -- Steaming Phial of Finesse 2
  191347, -- Steaming Phial of Finesse 3
  191354, -- Crystalline Phial of Perception 1
  191355, -- Crystalline Phial of Perception 2
  191356 -- Crystalline Phial of Perception 3  
}
KPNodeIDs = {
	{knid = 96353, kname = "Spear Scavenger", SkLine = 2877},
	{knid = 96354, kname = "Orbinid Observer", SkLine = 2877},
	{knid = 96355, kname = "Fungus Forager", SkLine = 2877},
	{knid = 96356, kname = "Carnivorous Connoisseur", SkLine = 2877},
	{knid = 96357, kname = "Blossom Browser", SkLine = 2877},
	{knid = 96358, kname = "Bountiful Harvests", SkLine = 2877},
	{knid = 96246, kname = "Mulching", SkLine = 2877},
	{knid = 96247, kname = "Cultivation", SkLine = 2877},
	{knid = 96248, kname = "Botany", SkLine = 2877},
	{knid = 96294, kname = "Irradiated", SkLine = 2877},
	{knid = 96295, kname = "Sporefused", SkLine = 2877},
	{knid = 96296, kname = "Altered", SkLine = 2877},
	{knid = 96297, kname = "Crystallized", SkLine = 2877},
	{knid = 96298, kname = "Overloading the Underground", SkLine = 2877},
	{knid = 100082, kname = "Ironclaw", SkLine = 2881},
	{knid = 100083, kname = "Aqirite", SkLine = 2881},
	{knid = 100084, kname = "Bismuth", SkLine = 2881},
	{knid = 100085, kname = "Plethora of Ore", SkLine = 2881},
	{knid = 100109, kname = "Seams", SkLine = 2881},
	{knid = 100110, kname = "Rich Deposits", SkLine = 2881},
	{knid = 100111, kname = "Mining Fundamentals", SkLine = 2881},
	{knid = 100158, kname = "Webbed", SkLine = 2881},
	{knid = 100159, kname = "Outlawed Techniques", SkLine = 2881},
	{knid = 100160, kname = "Weeping", SkLine = 2881},
	{knid = 100161, kname = "Crystallized", SkLine = 2881},
	{knid = 100162, kname = "Mastering the Mysterious", SkLine = 2881},
	{knid = 59697, kname = "Floriculture", SkLine = 2832},
	{knid = 59698, kname = "Fungiculture", SkLine = 2832},
	{knid = 59699, kname = "Arboriculture", SkLine = 2832},
	{knid = 59700, kname = "Horticulture", SkLine = 2832},
	{knid = 59701, kname = "Bountiful Harvests", SkLine = 2832},
	{knid = 59649, kname = "Cultivation", SkLine = 2832},
	{knid = 59650, kname = "Conversance", SkLine = 2832},
	{knid = 59651, kname = "Botany", SkLine = 2832},
	{knid = 59617, kname = "Decayed", SkLine = 2832},
	{knid = 59618, kname = "Titan-Touched", SkLine = 2832},
	{knid = 59619, kname = "Frigid", SkLine = 2832},
	{knid = 59620, kname = "Windswept", SkLine = 2832},
	{knid = 59621, kname = "Mastering the Elements", SkLine = 2832},
	{knid = 57260, kname = "Sorting", SkLine = 2833},
	{knid = 57261, kname = "Industrialization", SkLine = 2833},
	{knid = 57262, kname = "Surveying", SkLine = 2833},
	{knid = 57263, kname = "Mining Process", SkLine = 2833},
	{knid = 57291, kname = "Draconium", SkLine = 2833},
	{knid = 57292, kname = "Serevite", SkLine = 2833},
	{knid = 57293, kname = "Metallurgy", SkLine = 2833},
	{knid = 57341, kname = "Primal", SkLine = 2833},
	{knid = 57342, kname = "Titan-Touched", SkLine = 2833},
	{knid = 57343, kname = "Hardened", SkLine = 2833},
	{knid = 57344, kname = "Molten", SkLine = 2833},
	{knid = 57345, kname = "Mastering the Elements", SkLine = 2833}
}
VANIL = {
    {nid = 180751, name = "Floating Wreckage", VRB = "FlWr", Chk = false, Prio = 10, Art = "f"},
	{nid = 180682, name = "Oily Blackmouth School", VRB = "OiBlSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 180662, name = "Schooner Wreckage", VRB = "ScWr", Chk = false, Prio = 10, Art = "f"},
	{nid = 180685, name = "Waterlogged Wreckage", VRB = "WaWr", Chk = false, Prio = 10, Art = "f"},
	{nid = 180655, name = "Floating Debris", VRB = "FlDe", Chk = false, Prio = 10, Art = "f"},
	{nid = 180684, name = "Greater Sagefish School", VRB = "GrSaSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 180712, name = "Stonescale Eel Swarm", VRB = "StEeSw", Chk = false, Prio = 10, Art = "f"},
	{nid = 180658, name = "School of Deviate Fish", VRB = "ScDeFi", Chk = false, Prio = 10, Art = "f"},
	{nid = 180901, name = "Bloodsail Wreckage", VRB = "BlWr", Chk = false, Prio = 10, Art = "f"},
	{nid = 180683, name = "Firefin Snapper School", VRB = "FiSnSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 1731, name = "Copper Vein", VRB = "CopVei", Chk = false, Prio = 10, Art = "m"},
	{nid = 103714, name = "Copper Vein", VRB = "CopVei", Chk = false, Prio = 10, Art = "m"},
	{nid = 165658, name = "Dark Iron Deposit", VRB = "DaIrDe", Chk = false, Prio = 10, Art = "m"},
	{nid = 1734, name = "Gold Vein", VRB = "GolVei", Chk = false, Prio = 10, Art = "m"},
	{nid = 181109, name = "Gold Vein", VRB = "GolVei", Chk = false, Prio = 10, Art = "m"},
	{nid = 1735, name = "Iron Deposit", VRB = "IroDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 103710, name = "Iron Deposit", VRB = "IroDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 103712, name = "Iron Deposit", VRB = "IroDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 181069, name = "Large Obsidian Chunk", VRB = "LaObCh", Chk = false, Prio = 10, Art = "m"},
	{nid = 2040, name = "Mithril Deposit", VRB = "MitDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 73941, name = "Ooze Covered Gold Vein", VRB = "OoCoGo", Chk = false, Prio = 10, Art = "m"},
	{nid = 73939, name = "Ooze Covered Iron Deposit", VRB = "OoCoIr", Chk = false, Prio = 10, Art = "m"},
	{nid = 123310, name = "Ooze Covered Mithril Deposit", VRB = "OoCoMi", Chk = false, Prio = 10, Art = "m"},
	{nid = 177388, name = "Ooze Covered Rich Thorium Vein", VRB = "OoCoRiTh", Chk = false, Prio = 10, Art = "m"},
	{nid = 73940, name = "Ooze Covered Silver Vein", VRB = "OoCoSi", Chk = false, Prio = 10, Art = "m"},
	{nid = 123848, name = "Ooze Covered Thorium Vein", VRB = "OoCoTh", Chk = false, Prio = 10, Art = "m"},
	{nid = 123309, name = "Ooze Covered Truesilver Deposit", VRB = "OoCoTr", Chk = false, Prio = 10, Art = "m"},
	{nid = 175404, name = "Rich Thorium Vein", VRB = "RiThVe", Chk = false, Prio = 10, Art = "m"},
	{nid = 176644, name = "Rich Thorium Vein", VRB = "RiThVe", Chk = false, Prio = 10, Art = "m"},
	{nid = 1733, name = "Silver Vein", VRB = "SilVei", Chk = false, Prio = 10, Art = "m"},
	{nid = 181068, name = "Small Obsidian Chunk", VRB = "SmObCh", Chk = false, Prio = 10, Art = "m"},
	{nid = 324, name = "Small Thorium Vein", VRB = "SmThVe", Chk = false, Prio = 10, Art = "m"},
	{nid = 1732, name = "Tin Vein", VRB = "TinVei", Chk = false, Prio = 10, Art = "m"},
	{nid = 103709, name = "Tin Vein", VRB = "TinVei", Chk = false, Prio = 10, Art = "m"},
	{nid = 2047, name = "Truesilver Deposit", VRB = "TruDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 181108, name = "Truesilver Deposit", VRB = "TruDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 142141, name = "Arthas' Tears", VRB = "ArtTea", Chk = false, Prio = 10, Art = "h"},
	{nid = 176589, name = "Black Lotus", VRB = "BlaLot", Chk = false, Prio = 10, Art = "h"},
	{nid = 142143, name = "Blindweed", VRB = "Blindwe", Chk = false, Prio = 10, Art = "h"},
	{nid = 1621, name = "Briarthorn", VRB = "Briart", Chk = false, Prio = 10, Art = "h"},
	{nid = 1622, name = "Bruiseweed", VRB = "Bruise", Chk = false, Prio = 10, Art = "h"},
	{nid = 2044, name = "Dragon's Teeth", VRB = "DraTee", Chk = false, Prio = 10, Art = "h"},
	{nid = 176584, name = "Dreamfoil", VRB = "Dreamf", Chk = false, Prio = 10, Art = "h"},
	{nid = 1619, name = "Earthroot", VRB = "Earth", Chk = false, Prio = 10, Art = "h"},
	{nid = 2042, name = "Fadeleaf", VRB = "Fadel", Chk = false, Prio = 10, Art = "h"},
	{nid = 2866, name = "Firebloom", VRB = "Firebl", Chk = false, Prio = 10, Art = "h"},
	{nid = 142144, name = "Ghost Mushroom", VRB = "GhoMus", Chk = false, Prio = 10, Art = "h"},
	{nid = 176583, name = "Golden Sansam", VRB = "GolSan", Chk = false, Prio = 10, Art = "h"},
	{nid = 2046, name = "Goldthorn", VRB = "Goldth", Chk = false, Prio = 10, Art = "h"},
	{nid = 1628, name = "Grave Moss", VRB = "GraMos", Chk = false, Prio = 10, Art = "h"},
	{nid = 142145, name = "Gromsblood", VRB = "Gromsbl", Chk = false, Prio = 10, Art = "h"},
	{nid = 176588, name = "Icecap", VRB = "Iceca", Chk = false, Prio = 10, Art = "h"},
	{nid = 2043, name = "Khadgar's Whisker", VRB = "KhaWhi", Chk = false, Prio = 10, Art = "h"},
	{nid = 1624, name = "Kingsblood", VRB = "Kingsbl", Chk = false, Prio = 10, Art = "h"},
	{nid = 2041, name = "Liferoot", VRB = "Lifero", Chk = false, Prio = 10, Art = "h"},
	{nid = 1620, name = "Mageroyal", VRB = "Magero", Chk = false, Prio = 10, Art = "h"},
	{nid = 176586, name = "Mountain Silversage", VRB = "MouSil", Chk = false, Prio = 10, Art = "h"},
	{nid = 1618, name = "Peacebloom", VRB = "Peacebl", Chk = false, Prio = 10, Art = "h"},
	{nid = 142140, name = "Purple Lotus", VRB = "PurLot", Chk = false, Prio = 10, Art = "h"},
	{nid = 1617, name = "Silverleaf", VRB = "Silverl", Chk = false, Prio = 10, Art = "h"},
	{nid = 176587, name = "Sorrowmoss", VRB = "Sorrow", Chk = false, Prio = 10, Art = "h"},
	{nid = 2045, name = "Stranglekelp", VRB = "Strangl", Chk = false, Prio = 10, Art = "h"},
	{nid = 142142, name = "Sungrass", VRB = "Sungra", Chk = false, Prio = 10, Art = "h"},
	{nid = 1623, name = "Wild Steelbloom", VRB = "WilSte", Chk = false, Prio = 10, Art = "h"}
}
BC = {
    {nid = 182958, name = "Mudfish School", VRB = "MuSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 182957, name = "Highland Mixed School", VRB = "HiMiSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 182956, name = "School of Darter", VRB = "ScDa", Chk = false, Prio = 10, Art = "f"},
	{nid = 182952, name = "Steam Pump Flotsam", VRB = "StPuFl", Chk = false, Prio = 10, Art = "f"},
	{nid = 182959, name = "Bluefish School", VRB = "BlSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 182954, name = "Brackish Mixed School", VRB = "BrMiSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 182953, name = "Sporefish School", VRB = "SpoSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 182951, name = "Pure Water", VRB = "PuWa", Chk = false, Prio = 10, Art = "f"},
	{nid = 181557, name = "Khorium Vein", VRB = "KhorVei", Chk = false, Prio = 10, Art = "m"},
	{nid = 181556, name = "Adamantite Deposit", VRB = "AdaDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 181555, name = "Fel Iron Deposit", VRB = "FelIrDe", Chk = false, Prio = 10, Art = "m"},
	{nid = 181569, name = "Rich Adamantite Deposit", VRB = "RiAdDe", Chk = false, Prio = 10, Art = "m"},
	{nid = 181570, name = "Rich Adamantite Deposit", VRB = "RiAdDe", Chk = false, Prio = 10, Art = "m"},
	{nid = 185877, name = "Nethercite Deposit", VRB = "NetDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 185557, name = "Ancient Gem Vein", VRB = "AncGemV", Chk = false, Prio = 10, Art = "m"},
	{nid = 185881, name = "Netherdust Bush", VRB = "NetBus", Chk = false, Prio = 10, Art = "h"},
	{nid = 181278, name = "Ancient Lichen", VRB = "AncLic", Chk = false, Prio = 10, Art = "h"},
	{nid = 181271, name = "Dreaming Glory", VRB = "DreGlo", Chk = false, Prio = 10, Art = "h"},
	{nid = 181270, name = "Felweed", VRB = "Felwe", Chk = false, Prio = 10, Art = "h"},
	{nid = 181275, name = "Ragveil", VRB = "Ragve", Chk = false, Prio = 10, Art = "h"},
	{nid = 181280, name = "Nightmare Vine", VRB = "NighVin", Chk = false, Prio = 10, Art = "h"},
	{nid = 181276, name = "Flame Cap", VRB = "FlaCap", Chk = false, Prio = 10, Art = "h"},
	{nid = 181277, name = "Terocone", VRB = "Teroc", Chk = false, Prio = 10, Art = "h"},
	{nid = 181281, name = "Mana Thistle", VRB = "ManThi", Chk = false, Prio = 10, Art = "h"},
	{nid = 181279, name = "Netherbloom", VRB = "NethBl", Chk = false, Prio = 10, Art = "h"}
}
WLK = {
    {nid = 192053, name = "Deep Sea Monsterbelly School", VRB = "DeSeMoSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 192051, name = "Borean Man O' War School", VRB = "BoMaWaSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 192054, name = "Moonglow Cuttlefish School", VRB = "MoCuSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 192050, name = "Glacial Salmon School", VRB = "GlSaSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 194479, name = "Pool of Blood", VRB = "PoOfBl", Chk = false, Prio = 10, Art = "f"},
	{nid = 192048, name = "Dragonfin Angelfish School", VRB = "DrAnSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 192046, name = "Musselback Sculpin School", VRB = "MuScSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 192057, name = "Nettlefish School", VRB = "NeSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 192049, name = "Fangtooth Herring School", VRB = "FaHeSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 192059, name = "Glassfin Minnow School", VRB = "GlMiSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 192052, name = "Imperial Manta Ray School", VRB = "ImMaRaSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 189978, name = "Cobalt Deposit", VRB = "CobDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 191133, name = "Titanium Vein", VRB = "TitVei", Chk = false, Prio = 10, Art = "m"},
	{nid = 189980, name = "Saronite Deposit", VRB = "SarDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 189981, name = "Rich Saronite Deposit", VRB = "RiSarDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 189979, name = "Rich Cobalt Deposit", VRB = "RiCoDe", Chk = false, Prio = 10, Art = "m"},
	{nid = 195036, name = "Pure Saronite Deposit", VRB = "PuSaDe", Chk = false, Prio = 10, Art = "m"},
	{nid = 190172, name = "Icethorn", VRB = "Iceth", Chk = false, Prio = 10, Art = "h"},
	{nid = 191019, name = "Adder's Tongue", VRB = "AddTo", Chk = false, Prio = 10, Art = "h"},
	{nid = 190171, name = "Lichbloom", VRB = "Lichb", Chk = false, Prio = 10, Art = "h"},
	{nid = 189973, name = "Goldclover", VRB = "GolCl", Chk = false, Prio = 10, Art = "h"},
	{nid = 190170, name = "Talandra's Rose", VRB = "TalRos", Chk = false, Prio = 10, Art = "h"},
	{nid = 191303, name = "Firethorn", VRB = "Firet", Chk = false, Prio = 10, Art = "h"},
	{nid = 190169, name = "Tiger Lily", VRB = "TigLil", Chk = false, Prio = 10, Art = "h"},
	{nid = 190176, name = "Frost Lotus", VRB = "FrosLot", Chk = false, Prio = 10, Art = "h"},
	{nid = 190173, name = "Frozen Herb", VRB = "FrozHer", Chk = false, Prio = 10, Art = "h"},
	{nid = 190174, name = "Frozen Herb", VRB = "FrozHer", Chk = false, Prio = 10, Art = "h"},
	{nid = 190175, name = "Frozen Herb", VRB = "FrozHer", Chk = false, Prio = 10, Art = "h"}
}
CAT = {
    {nid = 202777, name = "Highland Guppy School", VRB = "HiGuSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 202780, name = "Fathom Eel Swarm", VRB = "FaEeSw", Chk = false, Prio = 10, Art = "f"},
	{nid = 202778, name = "Albino Cavefish School", VRB = "AlCaSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 210216, name = "Shipwreck Debris", VRB = "ShDe", Chk = false, Prio = 10, Art = "f"},
	{nid = 207724, name = "Shipwreck Debris", VRB = "ShDe", Chk = false, Prio = 10, Art = "f"},
	{nid = 208311, name = "Deepsea Sagefish School", VRB = "DeSaSc", Chk = false, Prio = 10, Art = "f"},	
	{nid = 202779, name = "Blackbelly Mudfish School", VRB = "BlMuSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 202776, name = "Mountain Trout School", VRB = "MoTrSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 207734, name = "Pool of Fire", VRB = "PoFi", Chk = false, Prio = 10, Art = "f"},
	{nid = 202738, name = "Elementium Vein", VRB = "EleVei", Chk = false, Prio = 10, Art = "m"},
	{nid = 202736, name = "Obsidium Deposit", VRB = "ObsDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 202737, name = "Pyrite Deposit", VRB = "PyrDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 202741, name = "Rich Elementium Vein", VRB = "RiElVei", Chk = false, Prio = 10, Art = "m"},
	{nid = 202739, name = "Rich Obsidium Deposit", VRB = "RiObsDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 202740, name = "Rich Pyrite Deposit", VRB = "RiPyrDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 202749, name = "Azshara's Veil", VRB = "AzsVei", Chk = false, Prio = 10, Art = "h"},
	{nid = 202747, name = "Cinderbloom", VRB = "Cinder", Chk = false, Prio = 10, Art = "h"},
	{nid = 202750, name = "Heartblossom", VRB = "Heartbl", Chk = false, Prio = 10, Art = "h"},
	{nid = 202748, name = "Stormvine", VRB = "Stormv", Chk = false, Prio = 10, Art = "h"},
	{nid = 202751, name = "Twilight Jasmine", VRB = "TwiJas", Chk = false, Prio = 10, Art = "h"},
	{nid = 202752, name = "Whiptail", VRB = "Whipt", Chk = false, Prio = 10, Art = "h"}
}
MOP = {
    {nid = 216764, name = "Sagefish School", VRB = "SaSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 212169, name = "Giant Mantis Shrimp Swarm", VRB = "GiMaShSw", Chk = false, Prio = 10, Art = "f"},
	{nid = 211423, name = "Shipwreck Debris", VRB = "ShDe", Chk = false, Prio = 10, Art = "f"},
	{nid = 218650, name = "Sha-Touched Spinefish", VRB = "ShToSp", Chk = false, Prio = 10, Art = "f"},
	{nid = 212175, name = "Tiger Gourami School", VRB = "TiGoSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 212174, name = "Reef Octopus Swarm", VRB = "ReOcSw", Chk = false, Prio = 10, Art = "f"},
	{nid = 221549, name = "Redbelly Mandarin School", VRB = "ReMaSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 221548, name = "Jewel Danio School", VRB = "JeDaSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 218539, name = "Large Swarm of Migrated Reef Octopus", VRB = "LaSwMiRe", Chk = false, Prio = 10, Art = "f"},
	{nid = 218629, name = "Glowing Jade Lungfish", VRB = "GlJaLu", Chk = false, Prio = 10, Art = "f"},
	{nid = 212172, name = "Krasarang Paddlefish School", VRB = "KrPaSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 218634, name = "Large Pool of Brew Frenzied Emperor Salmon", VRB = "LaPoBrFr", Chk = false, Prio = 10, Art = "f"},
	{nid = 218653, name = "Large Pool of Glimmering Jewel Danio", VRB = "LaPoGlJe", Chk = false, Prio = 10, Art = "f"},
	{nid = 218649, name = "Large Pool of Crowded Redbelly Mandarin", VRB = "LaPoGrRe", Chk = false, Prio = 10, Art = "f"},
	{nid = 212171, name = "Jade Lungfish School", VRB = "JaLuSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 218632, name = "Large Swarm of Panicked Paddlefish", VRB = "LaSwPaPa", Chk = false, Prio = 10, Art = "f"},
	{nid = 218652, name = "Glimmering Jewel Danio Pool", VRB = "GlJeDaPo", Chk = false, Prio = 10, Art = "f"},
	{nid = 218630, name = "Large Pool of Glowing Jade Lungfish", VRB = "LaPoGlJa", Chk = false, Prio = 10, Art = "f"},
	{nid = 216761, name = "Mixed Ocean School", VRB = "MiOcSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 218631, name = "Swarm of Panicked Paddlefish", VRB = "SwPaPa", Chk = false, Prio = 10, Art = "f"},
	{nid = 218633, name = "Brew Frenzied Emperor Salmon", VRB = "BrFrEmSa", Chk = false, Prio = 10, Art = "f"},
	{nid = 212163, name = "Emperor Salmon School", VRB = "EmSaSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 218636, name = "Large Pool of Tiger Gourami Slush", VRB = "LaPoTiGo", Chk = false, Prio = 10, Art = "f"},
	{nid = 218651, name = "Large Pool of Sha-Touched Spinefish", VRB = "LaPoShTo", Chk = false, Prio = 10, Art = "f"},
	{nid = 218576, name = "Large Tangled Mantis Shrimp Cluster", VRB = "LaTaMaSh", Chk = false, Prio = 10, Art = "f"},
	{nid = 218635, name = "Tiger Gourami Slush", VRB = "TiGoSl", Chk = false, Prio = 10, Art = "f"},
	{nid = 218648, name = "Crowded Redbelly Mandarin", VRB = "CrReMa", Chk = false, Prio = 10, Art = "f"},
	{nid = 212177, name = "Spinefish School", VRB = "SpiSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 218577, name = "Tangled Mantis Shrimp Cluster", VRB = "TaMaShCl", Chk = false, Prio = 10, Art = "f"},
	{nid = 218578, name = "Swarm of Migrated Reef Octopus", VRB = "SwMiReOc", Chk = false, Prio = 10, Art = "f"},
	{nid = 209311, name = "Ghost Iron Deposit", VRB = "GhIrDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 221538, name = "Ghost Iron Deposit", VRB = "GhIrDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 209312, name = "Kyparite Deposit", VRB = "KypDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 215414, name = "Kyparite Deposit", VRB = "KypDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 209328, name = "Rich Ghost Iron Deposit", VRB = "RiGhIrDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 221539, name = "Rich Ghost Iron Deposit", VRB = "RiGhIrDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 209329, name = "Rich Kyparite Deposit", VRB = "RiKyDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 215416, name = "Rich Kyparite Deposit", VRB = "RiKyDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 209330, name = "Rich Trillium Vein", VRB = "RiTrVe", Chk = false, Prio = 10, Art = "m"},
	{nid = 221540, name = "Rich Trillium Vein", VRB = "RiTrVe", Chk = false, Prio = 10, Art = "m"},
	{nid = 215417, name = "Rich Trillium Vein", VRB = "RiTrVe", Chk = false, Prio = 10, Art = "m"},
	{nid = 209313, name = "Trillium Vein", VRB = "TriVei", Chk = false, Prio = 10, Art = "m"},
	{nid = 221541, name = "Trillium Vein", VRB = "TriVei", Chk = false, Prio = 10, Art = "m"},
	{nid = 209355, name = "Fool's Cap", VRB = "FooCap", Chk = false, Prio = 10, Art = "h"},
	{nid = 221547, name = "Fool's Cap", VRB = "FooCap", Chk = false, Prio = 10, Art = "h"},
	{nid = 209354, name = "Golden Lotus", VRB = "GoldLot", Chk = false, Prio = 10, Art = "h"},
	{nid = 221545, name = "Golden Lotus", VRB = "GoldLot", Chk = false, Prio = 10, Art = "h"},
	{nid = 215409, name = "Golden Lotus", VRB = "GoldLot", Chk = false, Prio = 10, Art = "h"},
	{nid = 209349, name = "Green Tea Leaf", VRB = "GrTeLe", Chk = false, Prio = 10, Art = "h"},
	{nid = 221542, name = "Green Tea Leaf", VRB = "GrTeLe", Chk = false, Prio = 10, Art = "h"},
	{nid = 209353, name = "Rain Poppy", VRB = "RaiPop", Chk = false, Prio = 10, Art = "h"},
	{nid = 221543, name = "Rain Poppy", VRB = "RaiPop", Chk = false, Prio = 10, Art = "h"},
	{nid = 214510, name = "Sha-Touched Herb", VRB = "ShaToHe", Chk = false, Prio = 10, Art = "h"},
	{nid = 209350, name = "Silkweed", VRB = "Silkwe", Chk = false, Prio = 10, Art = "h"},
	{nid = 221544, name = "Silkweed", VRB = "Silkwe", Chk = false, Prio = 10, Art = "h"},
	{nid = 209351, name = "Snow Lily", VRB = "SnoLyl", Chk = false, Prio = 10, Art = "h"},
	{nid = 221546, name = "Snow Lily", VRB = "SnoLyl", Chk = false, Prio = 10, Art = "h"}
}
WOD = {
    {nid = 229071, name = "Sea Scorpion School", VRB = "SeScSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 229067, name = "Jawless Skulker School", VRB = "JaSkSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 229069, name = "Blind Lake Sturgeon School", VRB = "BlLaStSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 229072, name = "Abyssal Gulper School", VRB = "AbGuSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 229068, name = "Fat Sleeper School", VRB = "FaSlSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 237342, name = "Savage Piranha Pool", VRB = "SaPiPo", Chk = false, Prio = 10, Art = "f"},
	{nid = 229073, name = "Blackwater Whiptail School", VRB = "BlWhSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 229070, name = "Fire Ammonite School", VRB = "FiAmSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 227868, name = "Sparkling Pool", VRB = "SpaPoo", Chk = false, Prio = 10, Art = "f"},
	{nid = 243325, name = "Felmouth Frenzy School", VRB = "FeFrSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 243354, name = "Felmouth Frenzy School", VRB = "FeFrSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 237295, name = "Oily Sea Scorpion School", VRB = "OiSeScSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 236756, name = "Oily Abyssal Gulper School", VRB = "OiAbGuSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 228563, name = "Blackrock Deposit", VRB = "BlaDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 232542, name = "Blackrock Deposit", VRB = "BlaDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 237359, name = "Blackrock Deposit", VRB = "BlaDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 243313, name = "Blackrock Deposit", VRB = "BlaDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 243312, name = "Rich Blackrock Deposit", VRB = "RiBlaDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 232543, name = "Rich Blackrock Deposit", VRB = "RiBlaDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 237360, name = "Rich Blackrock Deposit", VRB = "RiBlaDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 228564, name = "Rich Blackrock Deposit", VRB = "RiBlaDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 243315, name = "Rich True Iron Deposit", VRB = "RiTrIrDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 228510, name = "Rich True Iron Deposit", VRB = "RiTrIrDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 237357, name = "Rich True Iron Deposit", VRB = "RiTrIrDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 232545, name = "Rich True Iron Deposit", VRB = "RiTrIrDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 230428, name = "Smoldering True Iron Deposit", VRB = "SmTrIrDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 232544, name = "True Iron Deposit", VRB = "TrIrDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 237358, name = "True Iron Deposit", VRB = "TrIrDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 243314, name = "True Iron Deposit", VRB = "TrIrDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 228493, name = "True Iron Deposit", VRB = "TrIrDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 235387, name = "Fireweed", VRB = "Firewe", Chk = false, Prio = 10, Art = "h"},
	{nid = 237396, name = "Fireweed", VRB = "Firewe", Chk = false, Prio = 10, Art = "h"},
	{nid = 228572, name = "Fireweed", VRB = "Firewe", Chk = false, Prio = 10, Art = "h"},
	{nid = 228571, name = "Frostweed", VRB = "Frostw", Chk = false, Prio = 10, Art = "h"},
	{nid = 233117, name = "Frostweed", VRB = "Frostw", Chk = false, Prio = 10, Art = "h"},
	{nid = 235376, name = "Frostweed", VRB = "Frostw", Chk = false, Prio = 10, Art = "h"},
	{nid = 237398, name = "Frostweed", VRB = "Frostw", Chk = false, Prio = 10, Art = "h"},
	{nid = 228573, name = "Gorgrond Flytrap", VRB = "GorFly", Chk = false, Prio = 10, Art = "h"},
	{nid = 235388, name = "Gorgrond Flytrap", VRB = "GorFly", Chk = false, Prio = 10, Art = "h"},
	{nid = 237402, name = "Gorgrond Flytrap", VRB = "GorFly", Chk = false, Prio = 10, Art = "h"},
	{nid = 228575, name = "Nagrand Arrowbloom", VRB = "NagArr", Chk = false, Prio = 10, Art = "h"},
	{nid = 235390, name = "Nagrand Arrowbloom", VRB = "NagArr", Chk = false, Prio = 10, Art = "h"},
	{nid = 237406, name = "Nagrand Arrowbloom", VRB = "NagArr", Chk = false, Prio = 10, Art = "h"},
	{nid = 228574, name = "Starflower", VRB = "Starfl", Chk = false, Prio = 10, Art = "h"},
	{nid = 237404, name = "Starflower", VRB = "Starfl", Chk = false, Prio = 10, Art = "h"},
	{nid = 235389, name = "Starflower", VRB = "Starfl", Chk = false, Prio = 10, Art = "h"},
	{nid = 237400, name = "Talador Orchid", VRB = "TalOrch", Chk = false, Prio = 10, Art = "h"},
	{nid = 235391, name = "Talador Orchid", VRB = "TalOrch", Chk = false, Prio = 10, Art = "h"},
	{nid = 228576, name = "Talador Orchid", VRB = "TalOrch", Chk = false, Prio = 10, Art = "h"},
	{nid = 243334, name = "Withered Herb", VRB = "WitHer", Chk = false, Prio = 10, Art = "h"}
}
LEG = {
    {nid = 246488, name = "Cursed Queenfish School", VRB = "CuQuSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 246489, name = "Mossgill Perch School", VRB = "MoPeSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 246493, name = "Black Barracuda School", VRB = "BlBaSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 246492, name = "Runescale Koi School", VRB = "RuKoSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 246491, name = "Fever of Stormrays", VRB = "FevSto", Chk = false, Prio = 10, Art = "f"},
	{nid = 246554, name = "Oodelfjiskenpool", VRB = "Oodel", Chk = false, Prio = 10, Art = "f"},
	{nid = 246490, name = "Highmountain Salmon School", VRB = "HiSaSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 247964, name = "Brimstone Destroyer Core", VRB = "BriDeCo", Chk = false, Prio = 10, Art = "m"},
	{nid = 247967, name = "Brimstone Destroyer Core", VRB = "BriDeCo", Chk = false, Prio = 10, Art = "m"},
	{nid = 247966, name = "Brimstone Destroyer Core", VRB = "BriDeCo", Chk = false, Prio = 10, Art = "m"},
	{nid = 247959, name = "Brimstone Destroyer Core", VRB = "BriDeCo", Chk = false, Prio = 10, Art = "m"},
	{nid = 247370, name = "Brimstone Destroyer Core", VRB = "BriDeCo", Chk = false, Prio = 10, Art = "m"},
	{nid = 247958, name = "Brimstone Destroyer Core", VRB = "BriDeCo", Chk = false, Prio = 10, Art = "m"},
	{nid = 247961, name = "Brimstone Destroyer Core", VRB = "BriDeCo", Chk = false, Prio = 10, Art = "m"},
	{nid = 247956, name = "Brimstone Destroyer Core", VRB = "BriDeCo", Chk = false, Prio = 10, Art = "m"},
	{nid = 247957, name = "Brimstone Destroyer Core", VRB = "BriDeCo", Chk = false, Prio = 10, Art = "m"},
	{nid = 247969, name = "Brimstone Destroyer Core", VRB = "BriDeCo", Chk = false, Prio = 10, Art = "m"},
	{nid = 247962, name = "Brimstone Destroyer Core", VRB = "BriDeCo", Chk = false, Prio = 10, Art = "m"},
	{nid = 247963, name = "Brimstone Destroyer Core", VRB = "BriDeCo", Chk = false, Prio = 10, Art = "m"},
	{nid = 247968, name = "Brimstone Destroyer Core", VRB = "BriDeCo", Chk = false, Prio = 10, Art = "m"},
	{nid = 247965, name = "Brimstone Destroyer Core", VRB = "BriDeCo", Chk = false, Prio = 10, Art = "m"},
	{nid = 247960, name = "Brimstone Destroyer Core", VRB = "BriDeCo", Chk = false, Prio = 10, Art = "m"},
	{nid = 272768, name = "Empyrium Deposit", VRB = "EmpDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 272780, name = "Empyrium Seam", VRB = "EmpSeam", Chk = false, Prio = 10, Art = "m"},
	{nid = 241743, name = "Felslate Deposit", VRB = "FelsDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 255344, name = "Felslate Seam", VRB = "FelsSeam", Chk = false, Prio = 10, Art = "m"},
	{nid = 268901, name = "Felslate Spike", VRB = "FelsSpik", Chk = false, Prio = 10, Art = "m"},
	{nid = 241726, name = "Leystone Deposit", VRB = "LeyDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 253280, name = "Leystone Seam", VRB = "LeySeam", Chk = false, Prio = 10, Art = "m"},
	{nid = 272778, name = "Rich Empyrium Deposit", VRB = "RiEmpDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 245325, name = "Rich Felslate Deposit", VRB = "RiFelsDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 245324, name = "Rich Leystone Deposit", VRB = "RiLeyDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 244774, name = "Aethril", VRB = "Aethr", Chk = false, Prio = 10, Art = "h"},
	{nid = 272782, name = "Astral Glory", VRB = "AstrGlo", Chk = false, Prio = 10, Art = "h"},
	{nid = 244775, name = "Dreamleaf", VRB = "Dreaml", Chk = false, Prio = 10, Art = "h"},
	{nid = 244776, name = "Dreamleaf", VRB = "Dreaml", Chk = false, Prio = 10, Art = "h"},
	{nid = 273052, name = "Fel-Encrusted Herb", VRB = "FeEnHe", Chk = false, Prio = 10, Art = "h"},
	{nid = 269278, name = "Fel-Encrusted Herb", VRB = "FeEnHe", Chk = false, Prio = 10, Art = "h"},
	{nid = 273053, name = "Fel-Encrusted Herb Cluster", VRB = "FeEnHeCl", Chk = false, Prio = 10, Art = "h"},
	{nid = 269887, name = "Fel-Encrusted Herb Cluster", VRB = "FeEnHeCl", Chk = false, Prio = 10, Art = "h"},
	{nid = 252404, name = "Felwort", VRB = "Felwo", Chk = false, Prio = 10, Art = "h"},
	{nid = 248010, name = "Felwort", VRB = "Felwo", Chk = false, Prio = 10, Art = "h"},
	{nid = 248000, name = "Felwort", VRB = "Felwo", Chk = false, Prio = 10, Art = "h"},
	{nid = 244786, name = "Felwort", VRB = "Felwo", Chk = false, Prio = 10, Art = "h"},
	{nid = 248001, name = "Felwort", VRB = "Felwo", Chk = false, Prio = 10, Art = "h"},
	{nid = 247999, name = "Felwort", VRB = "Felwo", Chk = false, Prio = 10, Art = "h"},
	{nid = 248009, name = "Felwort", VRB = "Felwo", Chk = false, Prio = 10, Art = "h"},
	{nid = 248011, name = "Felwort", VRB = "Felwo", Chk = false, Prio = 10, Art = "h"},
	{nid = 248004, name = "Felwort", VRB = "Felwo", Chk = false, Prio = 10, Art = "h"},
	{nid = 248005, name = "Felwort", VRB = "Felwo", Chk = false, Prio = 10, Art = "h"},
	{nid = 248007, name = "Felwort", VRB = "Felwo", Chk = false, Prio = 10, Art = "h"},
	{nid = 248008, name = "Felwort", VRB = "Felwo", Chk = false, Prio = 10, Art = "h"},
	{nid = 248002, name = "Felwort", VRB = "Felwo", Chk = false, Prio = 10, Art = "h"},
	{nid = 248003, name = "Felwort", VRB = "Felwo", Chk = false, Prio = 10, Art = "h"},
	{nid = 248006, name = "Felwort", VRB = "Felwo", Chk = false, Prio = 10, Art = "h"},
	{nid = 248012, name = "Felwort", VRB = "Felwo", Chk = false, Prio = 10, Art = "h"},
	{nid = 244777, name = "Fjarnskaggl", VRB = "Fjarnsk", Chk = false, Prio = 10, Art = "h"},
	{nid = 241641, name = "Foxflower", VRB = "Foxfl", Chk = false, Prio = 10, Art = "h"},
	{nid = 244778, name = "Starlight Rose", VRB = "StaRos", Chk = false, Prio = 10, Art = "h"}
}
BFA = {
    {nid = 341344, name = "Malformed Gnasher School", VRB = "MaGnSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 278406, name = "Lane Snapper School", VRB = "LaSnSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 278404, name = "Redtail Loach School", VRB = "ReLoSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 341343, name = "Aberrant Voidfin School", VRB = "AbVoSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 278405, name = "Frenzied Fangtooth School", VRB = "FrFaSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 278401, name = "Sand Shifter School", VRB = "SaShSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 278403, name = "Slimy Mackerel School", VRB = "SlMaSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 278402, name = "Tiragarde Perch School", VRB = "TiPeSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 327161, name = "Viper Fish School", VRB = "ViFiSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 293749, name = "Rasboralus School", VRB = "RasSch", Chk = false, Prio = 10, Art = "f"},
	{nid = 278399, name = "Great Sea Catfish School", VRB = "GrSeCaSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 327162, name = "Mauve Stinger School", VRB = "MaStSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 326054, name = "Sentry Fish School", VRB = "SeFiSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 323370, name = "Ionized Minnows", VRB = "IonMin", Chk = false, Prio = 10, Art = "f"},
	{nid = 276616, name = "Monelite Deposit", VRB = "MonDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 276619, name = "Monelite Seam", VRB = "MonSeam", Chk = false, Prio = 10, Art = "m"},
	{nid = 325875, name = "Osmenite Deposit", VRB = "OsmDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 325874, name = "Osmenite Seam", VRB = "OsmSeam", Chk = false, Prio = 10, Art = "m"},
	{nid = 276618, name = "Platinum Deposit", VRB = "PlatDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 276621, name = "Rich Monelite Deposit", VRB = "RiMonDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 325873, name = "Rich Osmenite Deposit", VRB = "RiOsmDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 276623, name = "Rich Platinum Deposit", VRB = "RiPlaDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 276622, name = "Rich Storm Silver Deposit", VRB = "RiStSiDe", Chk = false, Prio = 10, Art = "m"},
	{nid = 276617, name = "Storm Silver Deposit", VRB = "StSiDe", Chk = false, Prio = 10, Art = "m"},
	{nid = 276620, name = "Storm Silver Seam", VRB = "StSiSeam", Chk = false, Prio = 10, Art = "m"},
	{nid = 276237, name = "Akunda's Bite", VRB = "AkuBi", Chk = false, Prio = 10, Art = "h"},
	{nid = 276242, name = "Anchor Weed", VRB = "AnchWe", Chk = false, Prio = 10, Art = "h"},
	{nid = 294125, name = "Anchor Weed", VRB = "AnchWe", Chk = false, Prio = 10, Art = "h"},
	{nid = 281870, name = "Riverbud", VRB = "Riverb", Chk = false, Prio = 10, Art = "h"},
	{nid = 276234, name = "Riverbud", VRB = "Riverbud", Chk = false, Prio = 10, Art = "h"},
	{nid = 276240, name = "Sea Stalks", VRB = "SeaSta", Chk = false, Prio = 10, Art = "h"},
	{nid = 281872, name = "Sea Stalks", VRB = "SeaSta", Chk = false, Prio = 10, Art = "h"},
	{nid = 281869, name = "Siren's Sting", VRB = "SirStin", Chk = false, Prio = 10, Art = "h"},
	{nid = 276239, name = "Siren's Sting", VRB = "SirStin", Chk = false, Prio = 10, Art = "h"},
	{nid = 281867, name = "Star Moss", VRB = "StaMos", Chk = false, Prio = 10, Art = "h"},
	{nid = 281868, name = "Star Moss", VRB = "StaMos", Chk = false, Prio = 10, Art = "h"},
	{nid = 276236, name = "Star Moss", VRB = "StaMos", Chk = false, Prio = 10, Art = "h"},
	{nid = 281079, name = "Star Moss", VRB = "StaMos", Chk = false, Prio = 10, Art = "h"},
	{nid = 276238, name = "Winter's Kiss", VRB = "WinKis", Chk = false, Prio = 10, Art = "h"},
	{nid = 326598, name = "Zin'anthid", VRB = "ZinAnt", Chk = false, Prio = 10, Art = "h"}
}
SHAD = {
    {nid = 373437, name = "Pungent Blobfish Cluster", VRB = "PuBlCl", Chk = false, Prio = 10, Art = "f"},
	{nid = 373439, name = "Flipper Fish School", VRB = "FlFiSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 373441, name = "Aurelid Cluster", VRB = "AurClu", Chk = false, Prio = 10, Art = "f"},
	{nid = 370396, name = "Precursor Placoderm School", VRB = "PrPlSch", Chk = false, Prio = 10, Art = "f"},
	{nid = 349088, name = "Elysian Thade School", VRB = "ElThSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 349082, name = "Lost Sole School", VRB = "LoSoSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 328414, name = "Bubble-Eyed Rolly School", VRB = "BuEyRoSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 349083, name = "Iridescent Amberjack School", VRB = "IrAmSch", Chk = false, Prio = 10, Art = "f"},
	{nid = 349086, name = "Pocked Bonefish School", VRB = "PoBoSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 349084, name = "Silvergill Pike School", VRB = "SiPiSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 349087, name = "Spinefin Piranha School", VRB = "SpPiSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 349900, name = "Elethium Deposit", VRB = "EleDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 349898, name = "Laestrite Deposit", VRB = "LaeDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 349981, name = "Oxxein Deposit", VRB = "OxxDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 349982, name = "Phaedrum Deposit", VRB = "PhaDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 355508, name = "Phaedrum Deposit", VRB = "PhaDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 370400, name = "Progenium Deposit", VRB = "ProDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 350082, name = "Rich Elethium Deposit", VRB = "RiElDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 349899, name = "Rich Laestrite Deposit", VRB = "RiLaDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 350085, name = "Rich Oxxein Deposit", VRB = "RiOxxDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 350087, name = "Rich Phaedrum Deposit", VRB = "RiPhaDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 355507, name = "Rich Phaedrum Deposit", VRB = "RiPhaDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 370399, name = "Rich Progenium Deposit", VRB = "RiProDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 350084, name = "Rich Sinvyr Deposit", VRB = "RiSiDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 350086, name = "Rich Solenium Deposit", VRB = "RiSoDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 349983, name = "Sinvyr Deposit", VRB = "SinDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 349980, name = "Solenium Deposit", VRB = "SolDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 351469, name = "Death Blossom", VRB = "DeBlos", Chk = false, Prio = 10, Art = "h"},
	{nid = 336686, name = "Death Blossom", VRB = "DeBlos", Chk = false, Prio = 10, Art = "h"},
	{nid = 375101, name = "Death Blossom", VRB = "DeBlos", Chk = false, Prio = 10, Art = "h"},
	{nid = 375100, name = "Death Blossom", VRB = "DeBlos", Chk = false, Prio = 10, Art = "h"},
	{nid = 375099, name = "Death Blossom", VRB = "DeBlos", Chk = false, Prio = 10, Art = "h"},
	{nid = 351471, name = "Death Blossom", VRB = "DeBlos", Chk = false, Prio = 10, Art = "h"},
	{nid = 351470, name = "Death Blossom", VRB = "DeBlos", Chk = false, Prio = 10, Art = "h"},
	{nid = 375096, name = "Death Blossom", VRB = "DeBlos", Chk = false, Prio = 10, Art = "h"},
	{nid = 370398, name = "First Flower", VRB = "FiFlo", Chk = false, Prio = 10, Art = "h"},
	{nid = 370397, name = "Lush First Flower", VRB = "LuFiFo", Chk = false, Prio = 10, Art = "h"},
	{nid = 375071, name = "Lush Nightshade", VRB = "LuNig", Chk = false, Prio = 10, Art = "h"},
	{nid = 336689, name = "Marrowroot", VRB = "Marrow", Chk = false, Prio = 10, Art = "h"},
	{nid = 356537, name = "Nightshade", VRB = "Nights", Chk = false, Prio = 10, Art = "h"},
	{nid = 336691, name = "Nightshade", VRB = "Nights", Chk = false, Prio = 10, Art = "h"},
	{nid = 375097, name = "Nightshade", VRB = "Nights", Chk = false, Prio = 10, Art = "h"},
	{nid = 336690, name = "Rising Glory", VRB = "RisGlo", Chk = false, Prio = 10, Art = "h"},
	{nid = 336688, name = "Vigil's Torch", VRB = "VigTor", Chk = false, Prio = 10, Art = "h"},
	{nid = 336433, name = "Widowbloom", VRB = "Widowbl", Chk = false, Prio = 10, Art = "h"}
}
DF = {
	{nid = 382180, name = "Overheated Magma Thresher Pool", VRB = "OvMaTr", Chk = false, Prio = 10, Art = "f"},
	{nid = 382090, name = "Shimmering Treasure Pool", VRB = "ShTrPo", Chk = false, Prio = 10, Art = "f"},
	{nid = 377938, name = "Prismatic Leaper School", VRB = "PrLeSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 379275, name = "Fishing Pool", VRB = "FisPoo", Chk = false, Prio = 10, Art = "f"},
	{nid = 401847, name = "Disturbed Water", VRB = "DisWat", Chk = false, Prio = 10, Art = "f"},
	{nid = 377957, name = "Magma Thresher Pool", VRB = "MaThPo", Chk = false, Prio = 10, Art = "f"},
	{nid = 381098, name = "Aileron Seamoth School", VRB = "AiSeSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 402921, name = "Luminescent Cave Pool", VRB = "LuCaPo", Chk = false, Prio = 10, Art = "f"},
	{nid = 378271, name = "Rimefin Tuna Pool", VRB = "RiTuPo", Chk = false, Prio = 10, Art = "f"},
	{nid = 382123, name = "Deep Rimefin Tuna Pool", VRB = "DeRiTuPo", Chk = false, Prio = 10, Art = "f"},
	{nid = 381099, name = "Cerulean Spinefish School", VRB = "CeSpSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 381097, name = "Thousandbite Piranha Swarm", VRB = "ThPiSw", Chk = false, Prio = 10, Art = "f"},
	{nid = 381061, name = "Clubfish School", VRB = "CluSch", Chk = false, Prio = 10, Art = "f"},
	{nid = 381101, name = "Islefin Dorado Pool", VRB = "IsDoPo", Chk = false, Prio = 10, Art = "f"},
	{nid = 381096, name = "Scalebelly Mackerel Swarm", VRB = "ScaMaSw", Chk = false, Prio = 10, Art = "f"},
	{nid = 381717, name = "Lavafischschwarm", VRB = "LavFis", Chk = false, Prio = 10, Art = "f"},
	{nid = 381100, name = "Temporal Dragonhead Pool", VRB = "TeDrPo", Chk = false, Prio = 10, Art = "f"},
	{nid = 381102, name = "Serevite Deposit", VRB = "SerDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 407677, name = "Serevite Deposit", VRB = "SerDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 381103, name = "Serevite Deposit", VRB = "SerDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 381106, name = "Serevite Seam", VRB = "SerSeam", Chk = false, Prio = 10, Art = "m"},
	{nid = 381104, name = "Rich Serevite Deposit", VRB = "RichSer", Chk = false, Prio = 10, Art = "m"},
	{nid = 381105, name = "Rich Serevite Deposit", VRB = "RichSer", Chk = false, Prio = 10, Art = "m"},
	{nid = 407678, name = "Rich Serevite Deposit", VRB = "RichSer", Chk = false, Prio = 10, Art = "m"},
	{nid = 381518, name = "Primal Serevite Deposit", VRB = "PrmlSer", Chk = false, Prio = 10, Art = "m"},
	{nid = 381516, name = "Molten Serevite Deposit", VRB = "MltSer", Chk = false, Prio = 10, Art = "m"},
	{nid = 381519, name = "Infurious Serevite Deposit", VRB = "InfSer", Chk = false, Prio = 10, Art = "m"},
	{nid = 423573, name = "Infurious Serevite Deposit", VRB = "InfSer", Chk = false, Prio = 10, Art = "m"},
	{nid = 390137, name = "Metamorphic Serevite Deposit", VRB = "MetSer", Chk = false, Prio = 10, Art = "m"},
	{nid = 381517, name = "Titan-Touched Serevite Deposit", VRB = "TitSer", Chk = false, Prio = 10, Art = "m"},
	{nid = 407669, name = "Living Serevite Deposit", VRB = "LiveSer", Chk = false, Prio = 10, Art = "m"},
	{nid = 381515, name = "Hardened Serevite Deposit", VRB = "HardSer", Chk = false, Prio = 10, Art = "m"},
	{nid = 379252, name = "Draconium Deposit", VRB = "DracDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 407679, name = "Draconium Deposit", VRB = "DracDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 379248, name = "Draconium Deposit", VRB = "DracDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 379272, name = "Draconium Seam", VRB = "DracSeam", Chk = false, Prio = 10, Art = "m"},
	{nid = 375234, name = "Hardened Draconium Deposit", VRB = "HardDrac", Chk = false, Prio = 10, Art = "m"},
	{nid = 381479, name = "Hardened Shard", VRB = "HardSharD", Chk = false, Prio = 10, Art = "m"},
	{nid = 375240, name = "Infurious Draconium Deposit", VRB = "InfDrac", Chk = false, Prio = 10, Art = "m"},
	{nid = 390138, name = "Metamorphic Draconium Deposit", VRB = "MetDrac", Chk = false, Prio = 10, Art = "m"},
	{nid = 398747, name = "Metamorphic Spire", VRB = "MetSpire", Chk = false, Prio = 10, Art = "m"},
	{nid = 375235, name = "Molten Draconium Deposit", VRB = "MoltDrac", Chk = false, Prio = 10, Art = "m"},
	{nid = 375239, name = "Primal Draconium Deposit", VRB = "PrimalDrac", Chk = false, Prio = 10, Art = "m"},
	{nid = 384944, name = "Reverberating Boulder", VRB = "RevBould", Chk = false, Prio = 10, Art = "m"},
	{nid = 407681, name = "Rich Draconium Deposit", VRB = "RichDracDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 379267, name = "Rich Draconium Deposit", VRB = "RichDracDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 379263, name = "Rich Draconium Deposit", VRB = "RichDracDep", Chk = false, Prio = 10, Art = "m"},
	{nid = 375238, name = "Titan-Touched Draconium Deposit", VRB = "TitanDrac", Chk = false, Prio = 10, Art = "m"},
	{nid = 381212, name = "Decayed Hochenblume", VRB = "DeHoch", Chk = false, Prio = 10, Art = "h"},
	{nid = 381214, name = "Frigid Hochenblume", VRB = "FrigHoch", Chk = false, Prio = 10, Art = "h"},
	{nid = 382075, name = "Frozen Herb", VRB = "FrzHerb", Chk = false, Prio = 10, Art = "h"},
	{nid = 398757, name = "Hochenblume", VRB = "Hoch", Chk = false, Prio = 10, Art = "h"},
	{nid = 407703, name = "Hochenblume", VRB = "Hoch", Chk = false, Prio = 10, Art = "h"},
	{nid = 381209, name = "Hochenblume", VRB = "Hoch", Chk = false, Prio = 10, Art = "h"},
	{nid = 398766, name = "Infurious Hochenblume", VRB = "InfHoch", Chk = false, Prio = 10, Art = "h"},
	{nid = 409408, name = "Infurious Hochenblume", VRB = "InfHoch", Chk = false, Prio = 10, Art = "h"},
	{nid = 381211, name = "Infurious Hochenblume", VRB = "InfHoch", Chk = false, Prio = 10, Art = "h"},
	{nid = 390139, name = "Lambent Hochenblume", VRB = "LamHoch", Chk = false, Prio = 10, Art = "h"},
	{nid = 398753, name = "Lush Hochenblume", VRB = "LuHoch", Chk = false, Prio = 10, Art = "h"},
	{nid = 407705, name = "Lush Hochenblume", VRB = "LuHoch", Chk = false, Prio = 10, Art = "h"},
	{nid = 381960, name = "Lush Hochenblume", VRB = "LuHoch", Chk = false, Prio = 10, Art = "h"},
	{nid = 384296, name = "Self-Grown Decayed Hochenblume", VRB = "SelfDeHoch", Chk = false, Prio = 10, Art = "h"},
	{nid = 384291, name = "Self-Grown Hochenblume", VRB = "SelfHoch", Chk = false, Prio = 10, Art = "h"},
	{nid = 398761, name = "Titan-Touched Hochenblume", VRB = "TitHoch", Chk = false, Prio = 10, Art = "h"},
	{nid = 381210, name = "Titan-Touched Hochenblume", VRB = "TitHoch", Chk = false, Prio = 10, Art = "h"},
	{nid = 381213, name = "Windswept Hochenblume", VRB = "WindHoch", Chk = false, Prio = 10, Art = "h"},
	{nid = 375241, name = "Bubble Poppy", VRB = "BubPop", Chk = false, Prio = 10, Art = "h"},
	{nid = 407685, name = "Bubble Poppy", VRB = "BubPop", Chk = false, Prio = 10, Art = "h"},
	{nid = 398755, name = "Bubble Poppy", VRB = "BubPop", Chk = false, Prio = 10, Art = "h"},
	{nid = 375246, name = "Decayed Bubble Poppy", VRB = "DeBubPop", Chk = false, Prio = 10, Art = "h"},
	{nid = 375244, name = "Frigid Bubble Poppy", VRB = "FrigBubPop", Chk = false, Prio = 10, Art = "h"},
	{nid = 375243, name = "Infurious Bubble Poppy", VRB = "InfBubPop", Chk = false, Prio = 10, Art = "h"},
	{nid = 398764, name = "Infurious Bubble Poppy", VRB = "InfBubPop", Chk = false, Prio = 10, Art = "h"},
	{nid = 390142, name = "Lambent Bubble Poppy", VRB = "LamBubPop", Chk = false, Prio = 10, Art = "h"},
	{nid = 381957, name = "Lush Bubble Poppy", VRB = "LushBubPop", Chk = false, Prio = 10, Art = "h"},
	{nid = 407686, name = "Lush Bubble Poppy", VRB = "LushBubPop", Chk = false, Prio = 10, Art = "h"},
	{nid = 398751, name = "Lush Bubble Poppy", VRB = "LushBubPop", Chk = false, Prio = 10, Art = "h"},
	{nid = 384294, name = "Self-Grown Bubble Poppy", VRB = "SelfBubPop", Chk = false, Prio = 10, Art = "h"},
	{nid = 384299, name = "Self-Grown Decayed Bubble Poppy", VRB = "SelfDeBubPop", Chk = false, Prio = 10, Art = "h"},
	{nid = 375242, name = "Titan-Touched Bubble Poppy", VRB = "TitBubPop", Chk = false, Prio = 10, Art = "h"},
	{nid = 398759, name = "Titan-Touched Bubble Poppy", VRB = "TitBubPop", Chk = false, Prio = 10, Art = "h"},
	{nid = 375245, name = "Windswept Bubble Poppy", VRB = "WindBubPop", Chk = false, Prio = 10, Art = "h"},
	{nid = 381154, name = "Writhebark", VRB = "Bark", Chk = false, Prio = 10, Art = "h"},
	{nid = 407702, name = "Writhebark", VRB = "Bark", Chk = false, Prio = 10, Art = "h"},
	{nid = 398756, name = "Writhebark", VRB = "Bark", Chk = false, Prio = 10, Art = "h"},
	{nid = 381199, name = "Windswept Writhebark", VRB = "WindBark", Chk = false, Prio = 10, Art = "h"},
	{nid = 381196, name = "Titan-Touched Writhebark", VRB = "TitBark", Chk = false, Prio = 10, Art = "h"},
	{nid = 398760, name = "Titan-Touched Writhebark", VRB = "TitBark", Chk = false, Prio = 10, Art = "h"},
	{nid = 384293, name = "Self-Grown Writhebark", VRB = "SelfBark", Chk = false, Prio = 10, Art = "h"},
	{nid = 384298, name = "Self-Grown Decayed Writhebark", VRB = "SelfDeBark", Chk = false, Prio = 10, Art = "h"},
	{nid = 381958, name = "Lush Writhebark", VRB = "LuBark", Chk = false, Prio = 10, Art = "h"},
	{nid = 407707, name = "Lush Writhebark", VRB = "LuBark", Chk = false, Prio = 10, Art = "h"},
	{nid = 398752, name = "Lush Writhebark", VRB = "LuBark", Chk = false, Prio = 10, Art = "h"},
	{nid = 390141, name = "Lambent Writhebark", VRB = "LamBark", Chk = false, Prio = 10, Art = "h"},
	{nid = 381197, name = "Infurious Writhebark", VRB = "InfBark", Chk = false, Prio = 10, Art = "h"},
	{nid = 409405, name = "Infurious Writhebark", VRB = "InfBark", Chk = false, Prio = 10, Art = "h"},
	{nid = 398765, name = "Infurious Writhebark", VRB = "InfBark", Chk = false, Prio = 10, Art = "h"},
	{nid = 381200, name = "Frigid Writhebark", VRB = "FrigBark", Chk = false, Prio = 10, Art = "h"},
	{nid = 381198, name = "Decayed Writhebark", VRB = "DeBark", Chk = false, Prio = 10, Art = "h"},
	{nid = 381202, name = "Windswept Saxifrage", VRB = "WindSax", Chk = false, Prio = 10, Art = "h"},
	{nid = 381205, name = "Titan-Touched Saxifrage", VRB = "TitSax", Chk = false, Prio = 10, Art = "h"},
	{nid = 398762, name = "Titan-Touched Saxifrage", VRB = "TitSax", Chk = false, Prio = 10, Art = "h"},
	{nid = 384295, name = "Self-Grown Saxifrage", VRB = "SelfSax", Chk = false, Prio = 10, Art = "h"},
	{nid = 384297, name = "Self-Grown Decayed Saxifrage", VRB = "SelfDeSax", Chk = false, Prio = 10, Art = "h"},
	{nid = 381207, name = "Saxifrage", VRB = "Sax", Chk = false, Prio = 10, Art = "h"},
	{nid = 407701, name = "Saxifrage", VRB = "Sax", Chk = false, Prio = 10, Art = "h"},
	{nid = 398758, name = "Saxifrage", VRB = "Sax", Chk = false, Prio = 10, Art = "h"},
	{nid = 381959, name = "Lush Saxifrage", VRB = "LuSax", Chk = false, Prio = 10, Art = "h"},
	{nid = 407706, name = "Lush Saxifrage", VRB = "LuSax", Chk = false, Prio = 10, Art = "h"},
	{nid = 398754, name = "Lush Saxifrage", VRB = "LuSax", Chk = false, Prio = 10, Art = "h"},
	{nid = 390140, name = "Lambent Saxifrage", VRB = "LamSax", Chk = false, Prio = 10, Art = "h"},
	{nid = 381204, name = "Infurious Saxifrage", VRB = "InfSax", Chk = false, Prio = 10, Art = "h"},
	{nid = 398767, name = "Infurious Saxifrage", VRB = "InfSax", Chk = false, Prio = 10, Art = "h"},
	{nid = 409407, name = "Infurious Saxifrage", VRB = "InfSax", Chk = false, Prio = 10, Art = "h"},
	{nid = 381201, name = "Frigid Saxifrage", VRB = "FrigSax", Chk = false, Prio = 10, Art = "h"},
	{nid = 381203, name = "Decayed Saxifrage", VRB = "DeSax", Chk = false, Prio = 10, Art = "h"}
}
TWW = {
    {nid = 451669, name = "Glimmerpool", VRB = "Glim", Chk = false, Prio = 10, Art = "f"},
    {nid = 451670, name = "Calm Surfacing Ripple", VRB = "CaSuRi", Chk = false, Prio = 10, Art = "f"},
	{nid = 451671, name = "Bloody Perch Swarm", VRB = "BlPeSw", Chk = false, Prio = 10, Art = "f"},
	{nid = 451672, name = "Stargazer Swarm", VRB = "StSw", Chk = false, Prio = 10, Art = "f"},
	{nid = 451673, name = "Shore Treasure", VRB = "ShTr", Chk = false, Prio = 10, Art = "f"},
	{nid = 451674, name = "River Bass Pool", VRB = "RiBaPo", Chk = false, Prio = 10, Art = "f"},
	{nid = 451675, name = "Anglerseeker Torrent", VRB = "AngTor", Chk = false, Prio = 10, Art = "f"},
	{nid = 451676, name = "Floating Deep Treasure", VRB = "FlDeTr", Chk = false, Prio = 10, Art = "f"},
	{nid = 451677, name = "Festering Rotpool", VRB = "FeRo", Chk = false, Prio = 10, Art = "f"},
	{nid = 451678, name = "Blood in the Water", VRB = "BlInWa", Chk = false, Prio = 10, Art = "f"},
	{nid = 451679, name = "Infused Ichor Spill", VRB = "InIcSp", Chk = false, Prio = 10, Art = "f"},
    {nid = 451680, name = "Royal Ripple", VRB = "RoRi", Chk = false, Prio = 10, Art = "f"},
	{nid = 451681, name = "Swarm of Slum Sharks", VRB = "SwSlSh", Chk = false, Prio = 10, Art = "f"},
	{nid = 451682, name = "Whispers of the Deep", VRB = "WhOfDe", Chk = false, Prio = 10, Art = "f"},
	{nid = 414622, name = "Shadowblind Grouper School", VRB = "ShGrSc", Chk = false, Prio = 10, Art = "f"},
	{nid = 413047, name = "Aqirite", VRB = "Aqi", Chk = false, Prio = 10, Art = "m"},
    {nid = 434556, name = "Aqirite Chunk", VRB = "AqiChunk", Chk = false, Prio = 10, Art = "m"},
    {nid = 413881, name = "Aqirite Seam", VRB = "AqiSeam", Chk = false, Prio = 10, Art = "m"},
    {nid = 413046, name = "Bismuth", VRB = "Bis", Chk = false, Prio = 10, Art = "m"},
    {nid = 452082, name = "Bismuth", VRB = "Bis", Chk = false, Prio = 10, Art = "m"},
    {nid = 452080, name = "Bismuth", VRB = "Bis", Chk = false, Prio = 10, Art = "m"},
    {nid = 440211, name = "Bismuth", VRB = "Bis", Chk = false, Prio = 10, Art = "m"},
    {nid = 452076, name = "Bismuth", VRB = "Bis", Chk = false, Prio = 10, Art = "m"},
    {nid = 452081, name = "Bismuth", VRB = "Bis", Chk = false, Prio = 10, Art = "m"},
    {nid = 452079, name = "Bismuth", VRB = "Bis", Chk = false, Prio = 10, Art = "m"},
    {nid = 434558, name = "Bismuth Chunk", VRB = "BisChunk", Chk = false, Prio = 10, Art = "m"},
    {nid = 413880, name = "Bismuth Seam", VRB = "BisSeam", Chk = false, Prio = 10, Art = "m"},
    {nid = 413897, name = "Camouflaged Aqirite", VRB = "CamAqi", Chk = false, Prio = 10, Art = "m"},
    {nid = 413889, name = "Camouflaged Bismuth", VRB = "CamBis", Chk = false, Prio = 10, Art = "m"},
    {nid = 413907, name = "Camouflaged Ironclaw", VRB = "CamIrcl", Chk = false, Prio = 10, Art = "m"},
    {nid = 413890, name = "Crystallized Aqirite", VRB = "CryAqi", Chk = false, Prio = 10, Art = "m"},
    {nid = 413883, name = "Crystallized Bismuth", VRB = "CryBis", Chk = false, Prio = 10, Art = "m"},
    {nid = 413900, name = "Crystallized Ironclaw", VRB = "CryIrcl", Chk = false, Prio = 10, Art = "m"},
    {nid = 413895, name = "EZ-Mine Aqirite", VRB = "EZMineAqi", Chk = false, Prio = 10, Art = "m"},
    {nid = 413886, name = "EZ-Mine Bismuth", VRB = "EZMineBis", Chk = false, Prio = 10, Art = "m"},
    {nid = 413905, name = "EZ-Mine Ironclaw", VRB = "EZMineIrcl", Chk = false, Prio = 10, Art = "m"},
    {nid = 413049, name = "Ironclaw", VRB = "Ircl", Chk = false, Prio = 10, Art = "m"},
    {nid = 452075, name = "Ironclaw", VRB = "Ircl", Chk = false, Prio = 10, Art = "m"},
    {nid = 452067, name = "Ironclaw", VRB = "Ircl", Chk = false, Prio = 10, Art = "m"},
    {nid = 440219, name = "Ironclaw", VRB = "Ircl", Chk = false, Prio = 10, Art = "m"},
    {nid = 452063, name = "Ironclaw", VRB = "Ircl", Chk = false, Prio = 10, Art = "m"},
    {nid = 452070, name = "Ironclaw", VRB = "Ircl", Chk = false, Prio = 10, Art = "m"},
    {nid = 452083, name = "Ironclaw", VRB = "Ircl", Chk = false, Prio = 10, Art = "m"},
    {nid = 452066, name = "Ironclaw", VRB = "Ircl", Chk = false, Prio = 10, Art = "m"},
    {nid = 440214, name = "Ironclaw", VRB = "Ircl", Chk = false, Prio = 10, Art = "m"},
    {nid = 452060, name = "Ironclaw", VRB = "Ircl", Chk = false, Prio = 10, Art = "m"},
    {nid = 434557, name = "Ironclaw Chunk", VRB = "IrclChunk", Chk = false, Prio = 10, Art = "m"},
    {nid = 413882, name = "Ironclaw Seam", VRB = "IrclSeam", Chk = false, Prio = 10, Art = "m"},
    {nid = 413875, name = "Rich Aqirite", VRB = "RichAqi", Chk = false, Prio = 10, Art = "m"},
    {nid = 413874, name = "Rich Bismuth", VRB = "RichBis", Chk = false, Prio = 10, Art = "m"},
    {nid = 413877, name = "Rich Ironclaw", VRB = "RichIrcl", Chk = false, Prio = 10, Art = "m"},
    {nid = 430351, name = "Webbed Ore Deposit", VRB = "WOD", Chk = false, Prio = 10, Art = "m"},
    {nid = 430352, name = "Webbed Ore Deposit", VRB = "WOD", Chk = false, Prio = 10, Art = "m"},
    {nid = 430335, name = "Webbed Ore Deposit", VRB = "WOD", Chk = false, Prio = 10, Art = "m"},
    {nid = 413892, name = "Weeping Aqirite", VRB = "WepAqi", Chk = false, Prio = 10, Art = "m"},
    {nid = 413884, name = "Weeping Bismuth", VRB = "WepBis", Chk = false, Prio = 10, Art = "m"},
    {nid = 413902, name = "Weeping Ironclaw", VRB = "WepIrcl", Chk = false, Prio = 10, Art = "m"},
    {nid = 414331, name = "Altered Luredrop", VRB = "AltLdp", Chk = false, Prio = 10, Art = "h"},
    {nid = 414330, name = "Altered Mycobloom", VRB = "AltMcb", Chk = false, Prio = 10, Art = "h"},
    {nid = 414332, name = "Altered Orbinid", VRB = "AltOrbi", Chk = false, Prio = 10, Art = "h"},
    {nid = 414319, name = "Arathor's Spear", VRB = "ArSp", Chk = false, Prio = 10, Art = "h"},
    {nid = 454081, name = "Blessing Blossom", VRB = "BlB", Chk = false, Prio = 10, Art = "h"},
    {nid = 454086, name = "Blessing Blossom", VRB = "BlB", Chk = false, Prio = 10, Art = "h"},
    {nid = 414318, name = "Blessing Blossom", VRB = "BlB", Chk = false, Prio = 10, Art = "h"},
    {nid = 414344, name = "Camouflaged Arathor's Spear", VRB = "CamArSp", Chk = false, Prio = 10, Art = "h"},
    {nid = 414343, name = "Camouflaged Blessing Blossom", VRB = "CamBlB", Chk = false, Prio = 10, Art = "h"},
    {nid = 454078, name = "Camouflaged Blessing Blossom", VRB = "CamBlB", Chk = false, Prio = 10, Art = "h"},
    {nid = 454083, name = "Camouflaged Blessing Blossom", VRB = "CamBlB", Chk = false, Prio = 10, Art = "h"},
    {nid = 414341, name = "Camouflaged Luredrop", VRB = "CamLdp", Chk = false, Prio = 10, Art = "h"},
    {nid = 454007, name = "Camouflaged Luredrop", VRB = "CamLdp", Chk = false, Prio = 10, Art = "h"},
    {nid = 454051, name = "Camouflaged Luredrop", VRB = "CamLdp", Chk = false, Prio = 10, Art = "h"},
    {nid = 454065, name = "Camouflaged Mycobloom", VRB = "CamMcb", Chk = false, Prio = 10, Art = "h"},
    {nid = 414340, name = "Camouflaged Mycobloom", VRB = "CamMcb", Chk = false, Prio = 10, Art = "h"},
    {nid = 454068, name = "Camouflaged Mycobloom", VRB = "CamMcb", Chk = false, Prio = 10, Art = "h"},
    {nid = 454073, name = "Camouflaged Mycobloom", VRB = "CamMcb", Chk = false, Prio = 10, Art = "h"},
    {nid = 414342, name = "Camouflaged Orbinid", VRB = "CamOrbi", Chk = false, Prio = 10, Art = "h"},
    {nid = 414329, name = "Crystallized Arathor's Spear", VRB = "CryArSp", Chk = false, Prio = 10, Art = "h"},
    {nid = 414328, name = "Crystallized Blessing Blossom", VRB = "CryBlB", Chk = false, Prio = 10, Art = "h"},
    {nid = 414326, name = "Crystallized Luredrop", VRB = "CryLdp", Chk = false, Prio = 10, Art = "h"},
    {nid = 414325, name = "Crystallized Mycobloom", VRB = "CryMcb", Chk = false, Prio = 10, Art = "h"},
    {nid = 414327, name = "Crystallized Orbinid", VRB = "CryOrbi", Chk = false, Prio = 10, Art = "h"},
    {nid = 414339, name = "Irradiated Arathor's Spear", VRB = "IrArSp", Chk = false, Prio = 10, Art = "h"},
    {nid = 454079, name = "Irradiated Blessing Blossom", VRB = "IrBlB", Chk = false, Prio = 10, Art = "h"},
    {nid = 454084, name = "Irradiated Blessing Blossom", VRB = "IrBlB", Chk = false, Prio = 10, Art = "h"},
    {nid = 414338, name = "Irradiated Blessing Blossom", VRB = "IrBlB", Chk = false, Prio = 10, Art = "h"},
    {nid = 454008, name = "Irradiated Luredrop", VRB = "IrLdp", Chk = false, Prio = 10, Art = "h"},
    {nid = 454053, name = "Irradiated Luredrop", VRB = "IrLdp", Chk = false, Prio = 10, Art = "h"},
    {nid = 414336, name = "Irradiated Luredrop", VRB = "IrLdp", Chk = false, Prio = 10, Art = "h"},
    {nid = 414335, name = "Irradiated Mycobloom", VRB = "IrMcb", Chk = false, Prio = 10, Art = "h"},
    {nid = 454066, name = "Irradiated Mycobloom", VRB = "IrMcb", Chk = false, Prio = 10, Art = "h"},
    {nid = 454069, name = "Irradiated Mycobloom", VRB = "IrMcb", Chk = false, Prio = 10, Art = "h"},
    {nid = 454074, name = "Irradiated Mycobloom", VRB = "IrMcb", Chk = false, Prio = 10, Art = "h"},
    {nid = 414337, name = "Irradiated Orbinid", VRB = "IrOrbi", Chk = false, Prio = 10, Art = "h"},
    {nid = 452977, name = "Luredrop", VRB = "Ldp", Chk = false, Prio = 10, Art = "h"},
    {nid = 454010, name = "Luredrop", VRB = "Ldp", Chk = false, Prio = 10, Art = "h"},
    {nid = 440189, name = "Luredrop", VRB = "Ldp", Chk = false, Prio = 10, Art = "h"},
    {nid = 452975, name = "Luredrop", VRB = "Ldp", Chk = false, Prio = 10, Art = "h"},
    {nid = 440164, name = "Luredrop", VRB = "Ldp", Chk = false, Prio = 10, Art = "h"},
    {nid = 452972, name = "Luredrop", VRB = "Ldp", Chk = false, Prio = 10, Art = "h"},
    {nid = 454055, name = "Luredrop", VRB = "Ldp", Chk = false, Prio = 10, Art = "h"},
    {nid = 440162, name = "Luredrop", VRB = "Ldp", Chk = false, Prio = 10, Art = "h"},
    {nid = 452978, name = "Luredrop", VRB = "Ldp", Chk = false, Prio = 10, Art = "h"},
    {nid = 452976, name = "Luredrop", VRB = "Ldp", Chk = false, Prio = 10, Art = "h"},
    {nid = 414316, name = "Luredrop", VRB = "Ldp", Chk = false, Prio = 10, Art = "h"},
    {nid = 454545, name = "Luredrop", VRB = "Ldp", Chk = false, Prio = 10, Art = "h"},
    {nid = 440167, name = "Luredrop", VRB = "Ldp", Chk = false, Prio = 10, Art = "h"},
    {nid = 452973, name = "Luredrop", VRB = "Ldp", Chk = false, Prio = 10, Art = "h"},
    {nid = 440163, name = "Luredrop", VRB = "Ldp", Chk = false, Prio = 10, Art = "h"},
    {nid = 452971, name = "Luredrop", VRB = "Ldp", Chk = false, Prio = 10, Art = "h"},
    {nid = 452979, name = "Luredrop", VRB = "Ldp", Chk = false, Prio = 10, Art = "h"},
    {nid = 414324, name = "Lush Arathor's Spear", VRB = "LushArSp", Chk = false, Prio = 10, Art = "h"},
    {nid = 454080, name = "Lush Blessing Blossom", VRB = "LushBlB", Chk = false, Prio = 10, Art = "h"},
    {nid = 414323, name = "Lush Blessing Blossom", VRB = "LushBlB", Chk = false, Prio = 10, Art = "h"},
    {nid = 454085, name = "Lush Blessing Blossom", VRB = "LushBlB", Chk = false, Prio = 10, Art = "h"},
    {nid = 454009, name = "Lush Luredrop", VRB = "LushLdp", Chk = false, Prio = 10, Art = "h"},
    {nid = 414321, name = "Lush Luredrop", VRB = "LushLdp", Chk = false, Prio = 10, Art = "h"},
    {nid = 454054, name = "Lush Luredrop", VRB = "LushLdp", Chk = false, Prio = 10, Art = "h"},
    {nid = 454070, name = "Lush Mycobloom", VRB = "LushMcb", Chk = false, Prio = 10, Art = "h"},
    {nid = 414320, name = "Lush Mycobloom", VRB = "LushMcb", Chk = false, Prio = 10, Art = "h"},
    {nid = 454075, name = "Lush Mycobloom", VRB = "LushMcb", Chk = false, Prio = 10, Art = "h"},
    {nid = 454062, name = "Lush Mycobloom", VRB = "LushMcb", Chk = false, Prio = 10, Art = "h"},
    {nid = 414322, name = "Lush Orbinid", VRB = "LushOrbi", Chk = false, Prio = 10, Art = "h"},
    {nid = 440200, name = "Mycobloom", VRB = "Mcb", Chk = false, Prio = 10, Art = "h"},
    {nid = 454063, name = "Mycobloom", VRB = "Mcb", Chk = false, Prio = 10, Art = "h"},
    {nid = 414315, name = "Mycobloom", VRB = "Mcb", Chk = false, Prio = 10, Art = "h"},
    {nid = 440201, name = "Mycobloom", VRB = "Mcb", Chk = false, Prio = 10, Art = "h"},
    {nid = 440193, name = "Mycobloom", VRB = "Mcb", Chk = false, Prio = 10, Art = "h"},
    {nid = 454071, name = "Mycobloom", VRB = "Mcb", Chk = false, Prio = 10, Art = "h"},
    {nid = 454076, name = "Mycobloom", VRB = "Mcb", Chk = false, Prio = 10, Art = "h"},
    {nid = 440204, name = "Mycobloom", VRB = "Mcb", Chk = false, Prio = 10, Art = "h"},
    {nid = 452957, name = "Orbinid", VRB = "Orbi", Chk = false, Prio = 10, Art = "h"},
    {nid = 414317, name = "Orbinid", VRB = "Orbi", Chk = false, Prio = 10, Art = "h"},
    {nid = 452964, name = "Orbinid", VRB = "Orbi", Chk = false, Prio = 10, Art = "h"},
    {nid = 452955, name = "Orbinid", VRB = "Orbi", Chk = false, Prio = 10, Art = "h"},
    {nid = 452962, name = "Orbinid", VRB = "Orbi", Chk = false, Prio = 10, Art = "h"},
    {nid = 452953, name = "Orbinid", VRB = "Orbi", Chk = false, Prio = 10, Art = "h"},
    {nid = 452960, name = "Orbinid", VRB = "Orbi", Chk = false, Prio = 10, Art = "h"},
    {nid = 452950, name = "Orbinid", VRB = "Orbi", Chk = false, Prio = 10, Art = "h"},
    {nid = 452969, name = "Orbinid", VRB = "Orbi", Chk = false, Prio = 10, Art = "h"},
    {nid = 452958, name = "Orbinid", VRB = "Orbi", Chk = false, Prio = 10, Art = "h"},
    {nid = 452965, name = "Orbinid", VRB = "Orbi", Chk = false, Prio = 10, Art = "h"},
    {nid = 452956, name = "Orbinid", VRB = "Orbi", Chk = false, Prio = 10, Art = "h"},
    {nid = 452963, name = "Orbinid", VRB = "Orbi", Chk = false, Prio = 10, Art = "h"},
    {nid = 452954, name = "Orbinid", VRB = "Orbi", Chk = false, Prio = 10, Art = "h"},
    {nid = 452961, name = "Orbinid", VRB = "Orbi", Chk = false, Prio = 10, Art = "h"},
    {nid = 452952, name = "Orbinid", VRB = "Orbi", Chk = false, Prio = 10, Art = "h"},
    {nid = 452959, name = "Orbinid", VRB = "Orbi", Chk = false, Prio = 10, Art = "h"},
    {nid = 452948, name = "Orbinid", VRB = "Orbi", Chk = false, Prio = 10, Art = "h"},
    {nid = 452968, name = "Orbinid", VRB = "Orbi", Chk = false, Prio = 10, Art = "h"},
    {nid = 423363, name = "Sporefused Arathor's Spear", VRB = "SpfArSp", Chk = false, Prio = 10, Art = "h"},
    {nid = 423364, name = "Sporefused Blessing Blossom", VRB = "SpfBlB", Chk = false, Prio = 10, Art = "h"},
    {nid = 454077, name = "Sporefused Blessing Blossom", VRB = "SpfBlB", Chk = false, Prio = 10, Art = "h"},
    {nid = 454082, name = "Sporefused Blessing Blossom", VRB = "SpfBlB", Chk = false, Prio = 10, Art = "h"},
    {nid = 454006, name = "Sporefused Luredrop", VRB = "SpfLdp", Chk = false, Prio = 10, Art = "h"},
    {nid = 454050, name = "Sporefused Luredrop", VRB = "SpfLdp", Chk = false, Prio = 10, Art = "h"},
    {nid = 423366, name = "Sporefused Luredrop", VRB = "SpfLdp", Chk = false, Prio = 10, Art = "h"},
    {nid = 454072, name = "Sporefused Mycobloom", VRB = "SpfMcb", Chk = false, Prio = 10, Art = "h"},
    {nid = 423367, name = "Sporefused Mycobloom", VRB = "SpfMcb", Chk = false, Prio = 10, Art = "h"},
    {nid = 454064, name = "Sporefused Mycobloom", VRB = "SpfMcb", Chk = false, Prio = 10, Art = "h"},
    {nid = 454067, name = "Sporefused Mycobloom", VRB = "SpfMcb", Chk = false, Prio = 10, Art = "h"},
    {nid = 423368, name = "Sporefused Orbinid", VRB = "SpfOrbi", Chk = false, Prio = 10, Art = "h"},
    {nid = 429639, name = "Sporelusive Arathor's Spear", VRB = "SplArSp", Chk = false, Prio = 10, Art = "h"},
    {nid = 429644, name = "Sporelusive Arathor's Spear", VRB = "SplArSp", Chk = false, Prio = 10, Art = "h"},
    {nid = 429640, name = "Sporelusive Blessing Blossom", VRB = "SplBlB", Chk = false, Prio = 10, Art = "h"},
    {nid = 429645, name = "Sporelusive Blessing Blossom", VRB = "SplBlB", Chk = false, Prio = 10, Art = "h"},
    {nid = 429646, name = "Sporelusive Luredrop", VRB = "SplLdp", Chk = false, Prio = 10, Art = "h"},
    {nid = 429641, name = "Sporelusive Luredrop", VRB = "SplLdp", Chk = false, Prio = 10, Art = "h"},
    {nid = 429642, name = "Sporelusive Mycobloom", VRB = "SplMcb", Chk = false, Prio = 10, Art = "h"},
    {nid = 429647, name = "Sporelusive Mycobloom", VRB = "SplMcb", Chk = false, Prio = 10, Art = "h"},
    {nid = 429643, name = "Sporelusive Orbinid", VRB = "SplOrbi", Chk = false, Prio = 10, Art = "h"},
    {nid = 429648, name = "Sporelusive Orbinid", VRB = "SplOrbi", Chk = false, Prio = 10, Art = "h"}
}
nodes = {}
AreaFlags =
{
    None = 0x0;
    Terrain = 0x1;
    Water = 0x2;
    Deadly = 0x4;
    WMO = 0x8;
    Doodad = 0x10;
    Steeper = 0x20;
    Steep = 0x40;
    All = 0xFFFF;
}
local ThitFlags = bit.bor(0xFF,0xFFFF,0xFFFFF,0xFFFFFF,0xFFFFFFF,0xFFFFFFFF)
local hitFlags = bit.bor(0x1, 0x10, 0x100, 0x10000)
local hitFlagsWithoutWat = bit.bor(0x1, 0x10, 0x100)
local hitFlagsWMO = bit.bor(0x810,0x8010,0x80010)
local hitFlagsDE = bit.bor(0x4,0x40)
local AngleSteps = {0,-0.05,0.05,-0.1,0.1,-0.15,0.15,-0.2,0.2,-0.25,0.25,-0.3,0.3,-0.35,0.35,-0.4,0.4,-0.45,0.45,-0.5,0.5,
					-0.55,0.55,-0.6,0.6,-0.65,0.65,-0.7,0.7,-0.75,0.75,-0.8,0.8,-0.85,0.85,-0.9,0.9,-0.95,0.95,-1,1,
					-1.05,1.05,-1.1,1.1,-1.15,1.15,-1.2,1.2,-1.25,1.25,-1.3,1.3,-1.35,1.35,-1.4,1.4,-1.45,1.45,-1.5,1.5,
					-1.55,1.55,-1.6,1.6,-1.65,1.65,-1.7,1.7,-1.75,1.75,-1.8,1.8,-1.85,1.85,-1.9,1.9,-1.95,1.95,-2,2,
                    -2.05,2.05,-2.1,2.1,-2.15,2.15,-2.2,2.2,-2.25,2.25,-2.3,2.3,-2.35,2.35,-2.4,2.4,-2.45,2.45,-2.5,2.5,
					-2.55,2.55,-2.6,2.6,-2.65,2.65,-2.7,2.7,-2.75,2.75,-2.8,2.8,-2.85,2.85,-2.9,2.9,-2.95,2.95,-3,3,}

local AngleStepsFly = {0,-0.2,0.2,-0.4,0.4,-0.6,0.6,-0.8,0.8,-1,1,
					-1.2,1.2,-1.4,1.4,-1.6,1.6,-1.8,1.8,-2,2,
                    -2.2,2.2,-2.4,2.4,-2.6,2.6,-2.8,2.8,-3,3,}

local Flags = { NONE = 0x00000000, FORWARD = 0x00000001, BACKWARD = 0x00000002, STRAFELEFT = 0x00000004, STRAFERIGHT = 0x00000008, TURNLEFT = 0x00000010, TURNRIGHT = 0x00000020, 
PITCHUP = 0x00000040, PITCHDOWN = 0x00000080, WALKMODE = 0x00000100, ONTRANSPORT = 0x00000200, LEVITATING = 0x00000400, ROOT = 0x00000800, FALLING = 0x00001000, FALLINGFAR = 0x00002000, 
PENDINGSTOP = 0x00004000, PENDINGSTRAFESTOP = 0x00008000, PENDINGFORWARD = 0x00010000, PENDINGBACKWARD = 0x00020000, PENDINGSTRAFELEFT = 0x00040000, PENDINGSTRAFERIGHT = 0x00080000, 
PENDINGROOT = 0x00100000, SWIMMING = 0x00200000, ASCENDING = 0x00400000, DESCENDING = 0x00800000, CAN_FLY = 0x01000000, FLYING = 0x02000000, 
SPLINEELEVATION = 0x04000000, SPLINEENABLED = 0x08000000, WATERWALKING = 0x10000000, SAFEFALL = 0x20000000, HOVER = 0x40000000 } 


function _G.StartAKH()
	State = "IDLE"
end

function _G.StopAKH()
	State = "PAUSE"
end

function _G.FlyingAKHto(cx,cy,cz)
	State = "CUSTOM_MOVE"
	x,y,z = cx,cy,cz	
end

local function displayupdate(message)
    f1.text:SetText(message)
end



local function SwimmStuck()
	local success, result = pcall(function()
		if not LoadUi or State ~= "IDLE" then
			return
		end	
		--print(x,xxp,tarobject,fishpoolobj)
		if not IsSwimming() then	
			SwimmFreeze = false
		else 
			if not SwimmFreeze then
				SwimmFreeze = true
				SwimmFreezeTime = GetTime()
			else 
				if GetTime() > SwimmFreezeTime + 20 and not IsPlayerMoving() then
					Eval('ToggleAutoRun()','')
					C_Timer.After(1, function() Eval('ToggleAutoRun()','') end)
					print("Kup kup?")
				end
			end
		end	
	end)
	if success then
	  
	else
	   print("SwSt"..result)
	end
	C_Timer.After(5, SwimmStuck)
end
SwimmStuck()
local function CalculateAngleAndPitchToPoint(pointA, pointB)
    local randomex = math.random(1,5)
    local randomey = math.random(1,5)
    local dx = pointB.x - pointA.x
    local dy = pointB.y - pointA.y
    local dz = pointB.z - pointA.z

    local angle = math.atan2(dy, dx)
    local pitch = math.atan2(dz, math.sqrt(dx * dx + dy * dy))

    return angle, pitch
end

local function HSwalk()
	State = "INN"
	if not HSPath then
		local Map = select(8, GetInstanceInfo())
		for v, k in pairs(HSStore) do
			local x = k.HSPOINTS[1][1]
			local y = k.HSPOINTS[1][2]
			local z = k.HSPOINTS[1][3]
			local x,y,z = tonumber(x),tonumber(y),tonumber(z)
			if k.HSMAP == Map and FastDistance(px, py, pz, x,y,z) < 15 then
				print("Heartstone waypoints loaded")
				HSPath = k.HSPOINTS				
			end 
		end	
	end
	
	if HSPath and #HSPath > 1 then
		local pathIndex = 2 -- we are located at point 1, so start with 2

		local function FastDistance(x1, y1, z1, x2, y2, z2)
			local dx = x2 - x1
			local dy = y2 - y1
			local dz = z2 - z1
			return math.sqrt(dx*dx + dy*dy + dz*dz)
		end
		
		local function tickwalk()
			local tx = tonumber(HSPath[pathIndex][1])
			local ty = tonumber(HSPath[pathIndex][2])
			local tz = tonumber(HSPath[pathIndex][3])

			local distance = FastDistance(px, py, pz, tx, ty, tz)
			if distance < 1 then
				if pathIndex >= #HSPath then
					print("We are outside!")
					HSPath = nil
					Lastloot = GetTime()
					State = "IDLE"
					return
				end

				pathIndex = pathIndex + 1
				tx = tonumber(HSPath[pathIndex][1])
				ty = tonumber(HSPath[pathIndex][2])
				tz = tonumber(HSPath[pathIndex][3])

			end
			if not IsPlayerMoving() then
				MoveTo(tx, ty, tz)
			end
			if State ~= "PAUSE" then				
				C_Timer.After(0.05, tickwalk)
			end
		end
		local tx = tonumber(HSPath[1][1])
		local ty = tonumber(HSPath[1][2])
		local tz = tonumber(HSPath[1][3])
		
		MoveTo(tx, ty, tz)
		if State ~= "PAUSE" then
			tickwalk()
		end
	else
		print("Not possible to go outside. Location not supported!")
		State = "PAUSE"
	end
end

local function waterjump()
	local isUsable, insufficientPower = C_Spell.IsSpellUsable(372610)
	local CDown = C_Spell.GetSpellCooldown(372610)
	if isUsable and CDown.startTime == 0 then
			Eval('CastSpellByID(372610)', "")
	else
		C_Timer.After(0.01, waterjump)
	end
end

local function antiafk()
  SetLastHardwareActionTime(GetGameTick())
end

timer = C_Timer.NewTicker(25, function()
	if DeadmanTimer and DeadmanTimer < GetTime() then
		Eval('ReloadUI()', "")
	end
	antiafk()
end)

timer = C_Timer.NewTicker(5, function()
	if lootisopen and LootFrame:IsVisible() and (lootisopen+5) < GetTime() then
		print("Close loot window. Because it's been open for too long.")
		CloseLoot()
	end
end)

local function SettingsAKM()
	SettingsA = '{"Spot":"'..LoadRoute..'",\
	"Expansion":"'..LoadExpansion..'",\
	"Status":"'..Status..'",\
	"Gatherrange":"'..Gatherrange..'",\
	"BlacklRadius":"'..BlacklRadius..'",\
	"WhitelRadius":"'..WhitelRadius..'",\
	"Mobrange":"'..Mobrange..'",\
	"TMobrange":"'..TMobrange..'",\
	"HMobrange":"'..HMobrange..'",\
	"MMobrange":"'..MMobrange..'",\
	"FMobrange":"'..FMobrange..'",\
	"FlyForm":"'..FlyForm..'",\
	"MarshSpeed":"'..MarshSpeed..'",\
	"WVigor":"'..WVigor..'",\
	"NoPrio":"'..tostring(NoPrio)..'",\
	"NoPrioRange":"'..NoPrioRange..'",\
	"IgnoreGHigh":"'..tostring(IgnoreGHigh)..'",\
	"GuildBank":"'..tostring(GuildBank)..'",\
	"GBafterTime":"'..GBafterTime..'",\
	"TimeToUseGB":"'..TimeToUseGB..'",\
	"Mammut":"'..tostring(Mammut)..'",\
	"GuildRepair":"'..tostring(GuildRepair)..'",\
	"MammutSell":"'..tostring(MammutSell)..'",\
	"FreeSlots":"'..FreeSlots..'",\
	"SteadyFly":"'..tostring(SteadyFly)..'",\
	"OverHerb":"'..tostring(OverHerb)..'",\
	"Lambent":"'..tostring(Lambent)..'",\
	"OverOrb":"'..tostring(OverOrb)..'",\
	"ShowRPoints":"'..tostring(ShowRPoints)..'",\
	"ShowWPoints":"'..tostring(ShowWPoints)..'",\
	"ShowBPoints":"'..tostring(ShowBPoints)..'",\
	"Mail":"'..tostring(Mail)..'",\
	"HS":"'..tostring(HS)..'",\
	"HSafterTime":"'..HSafterTime..'",\
	"UIReload":"'..tostring(UIReload)..'",\
	"ReloadTimer":"'..ReloadTimer..'",\
	"AvoidMobs":"'..tostring(AvoidMobs)..'",\
	"TAvoidMobs":"'..tostring(TAvoidMobs)..'",\
	"HAvoidMobs":"'..tostring(HAvoidMobs)..'",\
	"MAvoidMobs":"'..tostring(MAvoidMobs)..'",\
	"FAvoidMobs":"'..tostring(FAvoidMobs)..'",\
	"AvoidElite":"'..tostring(AvoidElite)..'",\
	"TAvoidElite":"'..tostring(TAvoidElite)..'",\
	"HAvoidElite":"'..tostring(HAvoidElite)..'",\
	"MAvoidElite":"'..tostring(MAvoidElite)..'",\
	"FAvoidElite":"'..tostring(FAvoidElite)..'",\
	"LetGhoul":"'..tostring(LetGhoul)..'",\
	"Human":"'..tostring(Human)..'",\
	"FightMobs":"'..tostring(FightMobs)..'",\
	"MailChar":"'..MailChar..'",\
	"MailTime":"'..MailTime..'",\
	"TimeToSend":"'..TimeToSendMail..'",\
	"Truesight":"'..tostring(Truesight)..'",\
	"OwnScript":"'..tostring(OwnScript)..'",\
	"AutoUseTWWHProfBuild":"'..tostring(AutoUseTWWHProfBuild)..'",\
	"AutoUseTWWMProfBuild":"'..tostring(AutoUseTWWMProfBuild)..'",\
	"AutoUseDFHProfBuild":"'..tostring(AutoUseDFHProfBuild)..'",\
	"AutoUseDFMProfBuild":"'..tostring(AutoUseDFMProfBuild)..'",\
	"DefTWWHProfBuild":"'..tostring(DefTWWHProfBuild)..'",\
	"DefTWWMProfBuild":"'..tostring(DefTWWMProfBuild)..'",\
	"DefDFHProfBuild":"'..tostring(DefDFHProfBuild)..'",\
	"DefDFMProfBuild":"'..tostring(DefDFMProfBuild)..'",\
	"OwnTWWHProfBuild":"'..tostring(OwnTWWHProfBuild)..'",\
	"OwnTWWMProfBuild":"'..tostring(OwnTWWMProfBuild)..'",\
	"OwnDFHProfBuild":"'..tostring(OwnDFHProfBuild)..'",\
	"OwnDFMProfBuild":"'..tostring(OwnDFMProfBuild)..'",\
	"LoadScript":"'..tostring(LoadScript)..'",\
	"Bountiful":"'..tostring(Bountiful)..'",\
	"IronRazor":"'..tostring(IronRazor)..'",\
	"DFDeft":"'..tostring(DFDeft)..'",\
	"DFFines":"'..tostring(DFFines)..'",\
	"DFPerc":"'..tostring(DFPerc)..'",\
	"PriRazor":"'..tostring(PriRazor)..'",\
	"Firewater":"'..tostring(Firewater)..'",\
	"KPoints":"'..tostring(KPoints)..'",\
    "OnlyTWWGather":"'..tostring(OnlyTWWGather)..'",\
	"IgnWarChest":"'..tostring(IgnWarChest)..'",\
	"IgnoreTWWf":"'..tostring(IgnoreTWWf)..'",\
    "IgnoreTWWm":"'..tostring(IgnoreTWWm)..'",\
    "IgnoreTWWh":"'..tostring(IgnoreTWWh)..'"}'
	return SettingsA
end


function SaveSettings()
    if State == ("PAUSE") then
        Status = "PAUSE"
    else
        Status = "RUN"
    end
    IgnObj = {}
	PrioObj = {}
    lastnam = false
    for v, k in pairs(nodes) do
        if (not lastnam or (lastnam ~= k.name)) then
			if k.Chk == true then
				lastnam = k.name
				table.insert(IgnObj, lastnam)		
			end 
			if k.Prio < 10 then
				lastnam = k.name
				table.insert(PrioObj, {lastnam, k.Prio})		
			end
		end
    end	
	SettingsAKH = SettingsAKM()
    WriteFile("/scripts/AKH/Settings.json", SettingsAKH , false)  
	local bar = JSON:Encode(IgnObj)
	WriteFile("/scripts/AKH/IgnoreObjects.json", bar , false)
	WriteFile("/scripts/AKH/Ignore"..ExpObj.."Objects.json", bar , false)
	local bar1 = JSON:Encode(PrioObj)
	WriteFile("/scripts/AKH/PrioObjects.json", bar1 , false)
	WriteFile("/scripts/AKH/Prio"..ExpObj.."Objects.json", bar1 , false)
end


local function LoadBlacklistedPos()
    local SettingsBLPos = ReadFile('/scripts/AKH/Blacklist.json')
        if not SettingsBLPos then
        else 
            BlacklistedPlace = {}
            local File = ReadFile('/scripts/AKH/Blacklist.json')
            local Spot = JsonDecode(File)
            --Map = Spot.Continent    
            BlacklistedPlace = Spot.Points 
        end
end

local function SaveBlacklistedPos(px, py, pz, BlacklRadius)
    Map = select(8, GetInstanceInfo())			       
    table.insert(BlacklistedPlace, {px, py, pz, BlacklRadius})
    WriteFile("/scripts/AKH/BlacklistAKH.json", '{"Continent":'..Map..',\n"Points":[', false)
    local CountPoints = #BlacklistedPlace
    for v,k in pairs(BlacklistedPlace) do        
        local xb,yb,zb,rb = k[1],k[2],k[3],k[4]
        if v == CountPoints then
            WriteFile("/scripts/AKH/BlacklistAKH.json", '['..xb..','.. yb..','.. zb..',' ..rb ..']', true)
        else
            WriteFile("/scripts/AKH/BlacklistAKH.json", '['..xb..','.. yb..','.. zb..',' ..rb ..'],\n', true)
        end
    end
    WriteFile("/scripts/AKH/BlacklistAKH.json", ']}', true)   
    print("Added position to blacklist")           
end

local function LoadWhitelistedPos()
    local SettingsWLPos = ReadFile('/scripts/AKH/WhitelistAKH.json')
        if not SettingsWLPos then
        else 
            WhitelistedPlace = {}
            local File = ReadFile('/scripts/AKH/WhitelistAKH.json')
            local Spot = JsonDecode(File)
            --Map = Spot.Continent    
            WhitelistedPlace = Spot.Points 
        end
end

local function SaveWhitelistedPos(px, py, pz, WhitelRadius)
    Map = select(8, GetInstanceInfo())			       
    table.insert(WhitelistedPlace, {px, py, pz, WhitelRadius})
    WriteFile("/scripts/AKH/WhitelistAKH.json", '{"Continent":'..Map..',\n"Points":[', false)
    local CountPoints = #WhitelistedPlace
    for v,k in pairs(WhitelistedPlace) do        
        local xb,yb,zb,rb = k[1],k[2],k[3],k[4]
        if v == CountPoints then
            WriteFile("/scripts/AKH/WhitelistAKH.json", '['..xb..','.. yb..','.. zb..',' ..rb ..']', true)
        else
            WriteFile("/scripts/AKH/WhitelistAKH.json", '['..xb..','.. yb..','.. zb..',' ..rb ..'],\n', true)
        end
    end
    WriteFile("/scripts/AKH/WhitelistAKH.json", ']}', true)   
    print("Added position to whitelist")           
end                 
                    
local function LoadingGui()
    if LoadUi == nil then
        print("Load settings")
        LoadBlacklistedPos()
		LoadWhitelistedPos()

        local SettingsAK = ReadFile('/scripts/AKH/SettingsAKH.json')
        if not SettingsAK then
            print("Settings not found. Initialize.")
            State = "PAUSE"
        else
			local IgnSet = ReadFile('/scripts/AKH/IgnoreObjects.json')
            if IgnSet then
                IgnObj = JsonDecode(IgnSet)
            end
			local PrioSet = ReadFile('/scripts/AKH/PrioObjects.json')
            if PrioSet then
                PrioObj = JsonDecode(PrioSet)
            end
            Sets = JsonDecode(SettingsAK)
            SpotFile = ReadFile('/scripts/AKH/route/'..Sets.Spot..'.json')
            Spot = JsonDecode(SpotFile)
            Map = Spot.Continent
            Points = Spot.Points
            Status = Sets.Status
			if Sets.Expansion then
				LoadExpansion = Sets.Expansion
				if LoadExpansion == "Vanilla" then
					nodes = VANIL
					ExpObj = "Vanil"
				elseif LoadExpansion == "The Burning Crusade" then
					nodes = BC
					ExpObj = "BC"
				elseif LoadExpansion == "Wrath of the Lich King" then
					nodes = WLK
					ExpObj = "WLK"
				elseif LoadExpansion == "Cataclysm" then
					nodes = CAT
					ExpObj = "CAT"
				elseif LoadExpansion == "Mists of Pandaria" then
					nodes = MOP
					ExpObj = "MOP"
				elseif LoadExpansion == "Warlords of Draenor" then
					nodes = WOD
					ExpObj = "WOD"
				elseif LoadExpansion == "Legion" then
					nodes = LEG
					ExpObj = "LEG"
				elseif LoadExpansion == "Battle for Azeroth" then
					nodes = BFA
					ExpObj = "BFA"
				elseif LoadExpansion == "Shadowlands" then
					nodes = SHAD
					ExpObj = "SHAD"
				elseif LoadExpansion == "Dragonflight" then
					nodes = DF
					ExpObj = "DF"
				elseif LoadExpansion == "The War Within" then
					nodes = TWW
					ExpObj = "TWW"
				end
			else 
				LoadExpansion = "The War Within"
				nodes = TWW
				ExpObj = "TWW"
			end
            LoadRoute = Sets.Spot
			if Sets.Gatherrange then
				Gatherrange = tonumber(Sets.Gatherrange)
			else 
				Gatherrange = 500
			end
			if Sets.BlacklRadius then
				BlacklRadius = tonumber(Sets.BlacklRadius)
			else 
				BlacklRadius = 5
			end
			if Sets.WhitelRadius then
				WhitelRadius = tonumber(Sets.WhitelRadius)
			else 
				WhitelRadius = 5
			end
			if Sets.TMobrange then
				TMobrange = tonumber(Sets.TMobrange)
			else 
				TMobrange = 30
			end
			if Sets.HMobrange then
				HMobrange = tonumber(Sets.HMobrange)
			else 
				HMobrange = 30
			end
			if Sets.MMobrange then
				MMobrange = tonumber(Sets.MMobrange)
			else 
				MMobrange = 30
			end
			if Sets.FMobrange then
				FMobrange = tonumber(Sets.FMobrange)
			else 
				FMobrange = 30
			end
			if Sets.FlyForm then
				FlyForm = Sets.FlyForm
				if FlyForm == "Druid" then
					Druid = true
				else
					Druid = false
				end
			else
				FlyForm = "Random"
			end
			if Sets.MarshSpeed then
				MarshSpeed = tonumber(Sets.MarshSpeed)
			else 
				MarshSpeed = 11
			end
			if Sets.WVigor then
				WVigor = tonumber(Sets.WVigor)
			else 
				WVigor = 3
			end
			if Sets.NoPrio and Sets.NoPrio == "false" then
				NoPrio = false
			else 
				NoPrio = true
			end
			if Sets.NoPrioRange then
				NoPrioRange = tonumber(Sets.NoPrioRange)
			else 
				NoPrioRange = 20
			end
			if Sets.IgnoreGHigh and Sets.IgnoreGHigh == "true" then
				IgnoreGHigh = true
			else 
				IgnoreGHigh = false
			end
			if Sets.GuildBank and Sets.GuildBank == "true" then
				GuildBank = true
			else 
				GuildBank = false
			end
			if Sets.GBafterTime then
				GBafterTime = Sets.GBafterTime
				TimeToUseGB = tonumber(GBafterTime) * 3600 + time()
			else 
				GBafterTime = 2
			end
			if Sets.TimeToUseGB then
				TimeToUseGB = Sets.TimeToUseGB
				TimeToUseGB = tonumber(TimeToUseGB)
			else 
				TimeToUseGB = time()+200
			end
            if Sets.Mammut and Sets.Mammut == "true" then
				Mammut = true
			else 
				Mammut = false
			end
			if Sets.GuildRepair and Sets.GuildRepair == "true" then
				GuildRepair = true
			else 
				GuildRepair = false
			end
			if Sets.MammutSell and Sets.MammutSell == "true" then
				MammutSell = true
			else 
				MammutSell = false
			end
			if Sets.FreeSlots then
				FreeSlots = tonumber(Sets.FreeSlots)
			else 
				FreeSlots = 5
			end
			if Sets.SteadyFly and Sets.SteadyFly == "true" then
				SteadyFly = true
			else 
				SteadyFly = false
			end
			if Sets.OverHerb and Sets.OverHerb == "false" then
				OverHerb = false
			else 
				OverHerb = true
			end
			if Sets.Lambent and Sets.Lambent == "true" then
				Lambent = true
			else 
				Lambent = false
			end
			if Sets.OverOrb and Sets.OverOrb == "false" then
				OverOrb = false
			else 
				OverOrb = true
			end
			if Sets.ShowRPoints and Sets.ShowRPoints == "true" then
				ShowRPoints = true
			else 
				ShowRPoints = false
			end
			if Sets.ShowWPoints and Sets.ShowWPoints == "true" then
				ShowWPoints = true
			else 
				ShowWPoints = false
			end
			if Sets.ShowBPoints and Sets.ShowBPoints == "true" then
				ShowBPoints = true
			else 
				ShowBPoints = false
			end
			if Sets.HS and Sets.HS == "false" then
				HS = false
			else 
				HS = true
			end
			if Sets.HSafterTime then
				HSafterTime = Sets.HSafterTime
			else 
				HSafterTime = 10 
			end
			if Sets.UIReload and Sets.UIReload == "true" then
				UIReload = true
			else 
				UIReload = false
			end
			if Sets.ReloadTimer then
				ReloadTimer = Sets.ReloadTimer
			else 
				ReloadTimer = 1
			end
			if Sets.Mail and Sets.Mail == "true" then
				Mail = true
			else 
				Mail = false
			end
			if Sets.TAvoidMobs and Sets.TAvoidMobs == "true" then
				TAvoidMobs = true
			else 
				TAvoidMobs = false
			end
			if Sets.TAvoidElite and Sets.TAvoidElite == "true" then
				TAvoidElite = true
			else 
				TAvoidElite = false
			end
			if Sets.HAvoidMobs and Sets.HAvoidMobs == "true" then
				HAvoidMobs = true
			else 
				HAvoidMobs = false
			end
			if Sets.HAvoidElite and Sets.HAvoidElite == "true" then
				HAvoidElite = true
			else 
				HAvoidElite = false
			end
			if Sets.MAvoidMobs and Sets.MAvoidMobs == "true" then
				MAvoidMobs = true
			else 
				MAvoidMobs = false
			end
			if Sets.MAvoidElite and Sets.MAvoidElite == "true" then
				MAvoidElite = true
			else 
				MAvoidElite = false
			end
			if Sets.FAvoidMobs and Sets.FAvoidMobs == "true" then
				FAvoidMobs = true
			else 
				FAvoidMobs = false
			end
			if Sets.FAvoidElite and Sets.FAvoidElite == "true" then
				FAvoidElite = true
			else 
				FAvoidElite = false
			end
			if Sets.LetGhoul and Sets.LetGhoul == "true" then
				LetGhoul = true
			else 
				LetGhoul = false
			end
			if Sets.Human and Sets.Human == "true" then
				Human = true
			else 
				Human = false
			end
			if Sets.FightMobs and Sets.FightMobs == "true" then
				FightMobs = true
			else 
				FightMobs = false
			end
			if Sets.MailChar then
				MailChar = Sets.MailChar
			else 
				MailChar = "Your Char"
			end
			if Sets.MailTime then
				MailTime = Sets.MailTime
				TimeToSendMail = tonumber(MailTime) * 60 + time()
			else 
				MailTime = 120
			end
			if Sets.TimeToSend then
				TimeToSendMail = Sets.TimeToSend
				TimeToSendMail = tonumber(TimeToSendMail)
			else 
				
			end
			if Sets.Truesight and Sets.Truesight == "false" then
				Truesight = false
			else 
				Truesight = true
			end
			if Sets.OwnScript and Sets.OwnScript == "true" then
				OwnScript = true
			else 
				OwnScript = false
			end			
			if Sets.LoadScript then
				LoadScript = Sets.LoadScript
			else 
				LoadScript = nil
			end
			if Sets.AutoUseTWWHProfBuild and Sets.AutoUseTWWHProfBuild == "true" then
				AutoUseTWWHProfBuild = true
			else 
				AutoUseTWWHProfBuild = false
			end	
			if Sets.AutoUseTWWMProfBuild and Sets.AutoUseTWWMProfBuild == "true" then
				AutoUseTWWMProfBuild = true
			else 
				AutoUseTWWMProfBuild = false
			end
			if Sets.AutoUseDFHProfBuild and Sets.AutoUseDFHProfBuild == "true" then
				AutoUseDFHProfBuild = true
			else 
				AutoUseDFHProfBuild = false
			end
			if Sets.AutoUseDFMProfBuild and Sets.AutoUseDFMProfBuild == "true" then
				AutoUseDFMProfBuild = true
			else 
				AutoUseDFMProfBuild = false
			end
			if Sets.DefTWWHProfBuild and Sets.DefTWWHProfBuild == "false" then
				DefTWWHProfBuild = false
			else 
				DefTWWHProfBuild = true				
			end	
			if Sets.DefTWWMProfBuild and Sets.DefTWWMProfBuild == "false" then
				DefTWWMProfBuild = false
			else 
				DefTWWMProfBuild = true				
			end	
			if Sets.DefDFHProfBuild and Sets.DefDFHProfBuild == "false" then
				DefDFHProfBuild = false
			else 
				DefDFHProfBuild = true				
			end	
			if Sets.DefDFMProfBuild and Sets.DefDFMProfBuild == "false" then
				DefDFMProfBuild = false
			else 
				DefDFMProfBuild = true				
			end	
			if Sets.OwnTWWHProfBuild and Sets.OwnTWWHProfBuild == "true" then
				OwnTWWHProfBuild = true
			else 
				OwnTWWHProfBuild = false				
			end	
			if Sets.OwnTWWMProfBuild and Sets.OwnTWWMProfBuild == "true" then
				OwnTWWMProfBuild = true
			else 
				OwnTWWMProfBuild = false				
			end	
			if Sets.OwnDFHProfBuild and Sets.OwnDFHProfBuild == "true" then
				OwnDFHProfBuild = true
			else 
				OwnDFHProfBuild = false				
			end	
			if Sets.OwnDFMProfBuild and Sets.OwnDFMProfBuild == "true" then
				OwnDFMProfBuild = true
			else 
				OwnDFMProfBuild = false				
			end
			if Sets.Bountiful and Sets.Bountiful == "true" then
				Bountiful = true
			else 
				Bountiful = false
			end
			if Sets.IronRazor and Sets.IronRazor == "false" then
				IronRazor = false
			else 
				IronRazor = true
			end
			if Sets.DFDeft and Sets.DFDeft == "true" then
				DFDeft = true
			else 
				DFDeft = false
			end
			if Sets.DFFines and Sets.DFFines == "true" then
				DFFines = true
			else 
				DFFines = false
			end
			if Sets.DFPerc and Sets.DFPerc == "true" then
				DFPerc = true
			else 
				DFPerc = false
			end
			if Sets.PriRazor and Sets.PriRazor == "true" then
				PriRazor = true
			else 
				PriRazor = false
			end
			if Sets.Firewater and Sets.Firewater == "true" then
				Firewater = true
			else 
				Firewater = false
			end
			if Sets.KPoints and Sets.KPoints == "false" then
				KPoints = false
			else 
				KPoints = true
			end
            if Sets.OnlyTWWGather and Sets.OnlyTWWGather == "true" then
				OnlyTWWGather = true
			else 
				OnlyTWWGather = false
			end   
			if Sets.IgnWarChest and Sets.IgnWarChest == "true" then
				IgnWarChest = true
			else 
				IgnWarChest = false
			end 
			if Sets.IgnoreTWWf and Sets.IgnoreTWWf == "false" then
				IgnoreTWWf = false
            else 
				IgnoreTWWf = true
			end
            if Sets.IgnoreTWWm and Sets.IgnoreTWWm == "true" then
				IgnoreTWWm = true
            else 
				IgnoreTWWm = false
			end			
            if Sets.IgnoreTWWh and Sets.IgnoreTWWh == "true" then
				IgnoreTWWh = true
            else 
				IgnoreTWWh = false
			end
            for v, k in pairs(nodes) do
                if IgnoreTWWf == true and k.Art == "f" then     
                    k.Chk = true
				elseif IgnoreTWWm == true and k.Art == "m" then 
                    k.Chk = true
                elseif IgnoreTWWh == true and k.Art == "h" then 
                    k.Chk = true
                elseif IgnObj then
                    for i = 1, #IgnObj do
                        if k.name == IgnObj[i] then     
                            k.Chk = true
                        end
                    end
				end
				if PrioObj then
					for pv,pk in pairs(PrioObj) do
                        if k.name == pk[1] then     
                            k.Prio = pk[2]							
                        end
                    end
                end
            end
			if Status == ("PAUSE") then
				State = "PAUSE"
			else
				State = "IDLE"
			end
			if OwnScript and LoadScript then
				local success, result = pcall(function()
					ScriptCode = ReadFile('/scripts/AKH/OwnScripts/'..LoadScript..'.lua')
					Evaluator:Load(ScriptCode)
				end)
				if success then
				  
				else
				   print("OwnScLoa"..result)
				end
			end
            print("Settings loaded/ Gatherer Initialized/ Click Start to enable/disable")
            LoadUi = true
        end  
		C_Timer.After(1, LoadingGui)
	else
		return
    end
end
LoadingGui()
firstini = true



local prof1, prof2 = GetProfessions()
local prof1SkillID, prof2SkillID, _   
local isGatherer = false
if (prof1 ~= nil) then
	_,_,_,_,_,_,prof1SkillID = GetProfessionInfo(prof1)
end
if (prof2 ~= nil) then
	_,_,_,_,_,_,prof2SkillID = GetProfessionInfo(prof2)
end

local function checkProfession(id)          
	if id == 182 or id == 186 or id == 393 then
		return true
	end
	return false
end
local function checkEnchant(slot)
	local lua = loadstringsecure("data = C_TooltipInfo.GetInventoryItem('player'," ..slot..")")
    lua()
	if data ~= nil then
		for i in pairs(data.lines) do
			local line = data.lines[i]
			if line ~= nil and line.leftText ~= nil then
				local buff1 = string.find(line.leftText, "+45") 
				local buff2 = string.find(line.leftText, "+60")
				local buff3 = string.find(line.leftText, "+75")
				if buff1 or buff2 or buff3 then
					return true
				end
			end
		end		
		return false
	end
end

local function ItemnotUsable(itemsid)
	local lua = loadstringsecure("data = C_TooltipInfo.GetItemByID("..itemsid..")")
    lua()
	if data ~= nil then
		for i in pairs(data.lines) do
			local line = data.lines[i]
			if line ~= nil and line.leftColor.b ~= nil then
				local colorcheck = string.find(line.leftColor.b, "0.125") --49020349979
				if colorcheck then
					return true
				end
			end
		end		
		return false
	end
end
function NoSky()
	local nsx,nsy,nsz = TraceLine(px, py, pz, px, py, pz+10, hitFlags)
	if nsx == 0 then
		return false
	else
		return true
	end
end
-- create Farmroute--
local function CreateRoute()
	if Pathing == true then
		if IsFlying() then 
			if not LastPoint then  
				Map = select(8, GetInstanceInfo())			       
				table.insert(Points, {px, py, pz, farmradius})
					WriteFile("/scripts/AKH/route/"..NewRoute..".json", '{"Continent":'..Map..',\n"Points":[['..px..','.. py..','.. pz..',' ..farmradius ..'],\n', false)
					print("Add first point")  
				LastPoint = true
				x,y,z = px, py, pz
			else
				if FastDistance2D(x,y, px, py) >= farmradius then
					print("Add next point") 
					table.insert(Points, {px, py, pz, farmradius})
					WriteFile("/scripts/AKH/route/"..NewRoute..".json", '['..px..','.. py..','.. pz..',' ..farmradius ..'],\n', true)
					x,y,z = px, py, pz
				end
			end    
		end
		C_Timer.After(0.05, CreateRoute)	
	else
		return
	end
end

local function NextPoint()
	tarobject = nil
	fishpool = nil
    Shortdist = nil
    CountPoints = #Points
    if not LastPoint then
        for v,k in pairs(Points) do
        xp,yp,zp,rp = k[1],k[2],k[3],k[4]
        local distance = FastDistance2D(px, py, xp, yp)
            if not Shortdist then
                Shortdist = distance
                xfp,yfp,zfp,rfp = xp,yp,zp,rp
                LastPoint = v
            elseif Shortdist and distance < Shortdist then
                Shortdist = distance
                xfp,yfp,zfp,rfp = xp,yp,zp,rp
                LastPoint = v
            end
        end
        x,y,z,r = xfp,yfp,zfp,rfp
        return   
    else
        for v,k in pairs(Points) do
            if LastPoint and LastPoint== CountPoints and v == 1 then
                x,y,z,r = k[1],k[2],k[3],k[4]
                xfp,yfp,zfp,rfp = x,y,z,r
                LastPoint = v
                return
            elseif LastPoint < v then 
                x,y,z,r = k[1],k[2],k[3],k[4]
                xfp,yfp,zfp,rfp = x,y,z,r
                LastPoint = v
                return
            end
        end
    end
end

local function PoolLandPlace(plx, ply, plz)
	if not plz then
        return 0,0,0
    end
    local minz = nil
	local goodplace = nil
	for i = 5, 360, 5 do	
		local Rota = ObjectRotation('player') + math.rad(i) 
		local XL, YL, ZL = RotateVector(plx, ply, plz, Rota, 13)
		local hitx, hity, hitz = TraceLine(XL, YL, ZL+5, XL, YL, (ZL-1), hitFlagsWithoutWat)
		if hitx ~= 0 then	
			goodplace = true		
			for i = 15, 360, 15 do	
				local Rota1 = ObjectRotation('player') + math.rad(i) 
				local XL1, YL1, ZL1 = RotateVector(hitx, hity, hitz, Rota1, 1)
				local hitx1, hity1, hitz1 = TraceLine(XL1, YL1, ZL1+0.75, XL1, YL1, (ZL1-0.75), hitFlagsWithoutWat)
				if hitx1 == 0 then
					goodplace = nil
				end
			end
		end
		if goodplace then 
			foundpoollandplace = true
			return hitx, hity, hitz
		end
	end
	print("Ignore Pool. Reason: No place to land near pool")
	print(x, y, z)
	table.insert(LandBlacklistedPlace, {plx, ply, plz, 3})
	tarobject = nil	
	return 0,0,0
end

local function NodeLandPlace(x, y, z)
	if not z then
        return 0,0,0
    end
    local minz = nil
	local rx,ry,rz
	local goodplace = nil
	local z = z+4
	local NodDist
	local rotagrad
	if SteadyFly == true then 
		rotagrad = 1
	else
		rotagrad = 5
	end
	for i = rotagrad, 360, rotagrad do	
		local Rota = ObjectRotation('player') + math.rad(i) 
		if SteadyFly == true then 
			NodDist = 2
		else
			NodDist = 1
		end
		local XL, YL, ZL = RotateVector(x, y, z, Rota, NodDist)
		local hitx, hity, hitz = TraceLine(XL, YL, ZL, XL, YL, (ZL-5), hitFlags)
		--local hitwx, hitwy, hitwz = TraceLine(XL, YL, ZL, XL, YL, (ZL-5), 0x20000)
		--if hitx ~= 0 and hitwx == 0 then	
		if hitx ~= 0 then
			goodplace = true
		end
		if hitx == 0 then
			hitz = z+5
		end
		if not minz then 
			minz = hitz
			rx,ry,rz = hitx, hity, hitz
		else
			if hitz < minz then
				minz = hitz
				rx,ry,rz = hitx, hity, hitz
			end
		end
	end
	if goodplace then 
		foundlandplace = true
		return rx,ry,rz
	end
	print("Ignore Node. Reason: No place to land near node")
	print(x, y, z)
	table.insert(LandBlacklistedPlace, {x, y, z, 3})
	tarobject = nil	
	return 0,0,0
end

local function SetAnglePitch(ang,pit)
	local DirCurr = ObjectRotation('player')
	local XXD, YYD, ZZD = RotateVector(px, py, pz, DirCurr, 20)
	local XD, YD, ZD = RotateVector(px, py, pz, ang, 20)
	local DirCurrent, _ = CalculateAngleAndPitchToPoint({x=px,y=py,z=pz},{x=XXD,y=YYD,z=ZZD}) 
	
	--print(DirCurrent.."   "..DirToReach)
	
	
	--if pit > (-1.3) then
		--pit = tonumber(pit-0.05)
		if not Lootdistance then
			SetPitch(pit)
		end
		if Lootdistance and Lootdistance > 6 then
			if pit < (-1) then
				SetPitch(pit+(-0.1))
			elseif (pit > (-0.5) or pit < 0.5) then
				if Targetdistance <= 15 then 
					SetPitch(pit+(-0.15))
				else
					SetPitch(pit)
				end
			end
		end
		local timeElapsed = (GetTime() - LastAngTime)		
		if timeElapsed > 0.2 and ((ang-DirCurrent) < (-0.1) or (ang-DirCurrent) > (0.1)) then
			LastAngTime = GetTime()
			if Lootdistance and Lootdistance < 6 then
				SetPitch(pit)
			end
			if Human then --and Targetdistance and Targetdistance > 20 then
				FaceDirection(ang, true)				
			else
				FaceDirection((ang % (2*math.pi)), false)
				SendMovementHeartbeat() 
			end
		end
		SendMovementHeartbeat()
	--end
end

local function TrLiPlayerToNode(px, py, pz, thpz, x, y, z, thnz)
    local l = ObjectRotation('player') + math.rad(90) 
	local r = ObjectRotation('player') - math.rad(90)
	local z = z
	local tracing = "Var1" 
	for i = 1, 300, 1 do	
		local XL, YL, ZL = RotateVector(x, y, z, l, i)
		local hitx, hity, hitz = TraceLine(px, py, pz, XL, YL, ZL, hitFlags)
		if hitx == 0 then
			local angle, calced_pitch = CalculateAngleAndPitchToPoint({x=px,y=py,z=pz},{x=XL,y=YL,z=ZL})
			SetAnglePitch(angle, calced_pitch)
			tracing = "Var1.1" 
			return tracing
		end 					
		local XR, YR, ZR = RotateVector(x, y, z, r, i)
		local hitx, hity, hitz = TraceLine(px, py, pz, XR, YR, ZR, hitFlags)
		if hitx == 0 then
			local angle, calced_pitch = CalculateAngleAndPitchToPoint({x=px,y=py,z=pz},{x=XR,y=YR,z=ZR})
			SetAnglePitch(angle, calced_pitch)
			tracing = "Var1.2" 
			return tracing
		end 
		local XLW2, YLW2, ZLW2 = RotateVector(x, y, z+(i/2), l, i)
		local hitx, hity, hitz = TraceLine(px, py, pz, XLW2, YLW2, ZLW2, hitFlags)
		if hitx == 0 then
			local angle, calced_pitch = CalculateAngleAndPitchToPoint({x=px,y=py,z=pz},{x=XLW2,y=YLW2,z=ZLW2})
			SetAnglePitch(angle, calced_pitch)
			tracing = "Var1.3" 
			return tracing
		end 
		local XRW2, YRW2, ZRW2 = RotateVector(x, y, z+(i/2), r, i)
		local hitx, hity, hitz = TraceLine(px, py, pz, XRW2, YRW2, ZRW2, hitFlags)
		if hitx == 0 then
			local angle, calced_pitch = CalculateAngleAndPitchToPoint({x=px,y=py,z=pz},{x=XRW2,y=YRW2,z=ZRW2})
			SetAnglePitch(angle, calced_pitch)
			tracing = "Var1.4" 
			return tracing
		end 
		local XLW, YLW, ZLW = RotateVector(x, y, z+i, l, i)
		local hitx, hity, hitz = TraceLine(px, py, pz, XLW, YLW, ZLW, hitFlags)
		if hitx == 0 then
			local angle, calced_pitch = CalculateAngleAndPitchToPoint({x=px,y=py,z=pz},{x=XLW,y=YLW,z=ZLW})
			SetAnglePitch(angle, calced_pitch)
			tracing = "Var1.5" 
			return tracing
		end 
		local XRW, YRW, ZRW = RotateVector(x, y, z+i, r, i)
		local hitx, hity, hitz = TraceLine(px, py, pz, XRW, YRW, ZRW, hitFlags)
		if hitx == 0 then
			local angle, calced_pitch = CalculateAngleAndPitchToPoint({x=px,y=py,z=pz},{x=XRW,y=YRW,z=ZRW})
			SetAnglePitch(angle, calced_pitch)
			tracing = "Var1.6" 
			return tracing
		end
	end
	for i = -300, 300, 1 do
		local hitx, hity, hitz = TraceLine(px, py, pz, x, y, z+i, hitFlags)
		if hitx == 0 then
			local angle, calced_pitch = CalculateAngleAndPitchToPoint({x=px,y=py,z=pz},{x=px,y=py,z=(pz+i)})
			SetAnglePitch(angle, calced_pitch)
			tracing = "Var1.7" 
			return tracing
		end 
	end
	for i = -300, 300, 1 do
		local hitx, hity, hitz = TraceLine(px, py, pz+i, x, y, z+4, hitFlags)
		if hitx == 0 then
			local hit1x, hit1y, hit1z = TraceLine(px, py, pz, px, py, pz+i, hitFlags)
			if hit1x == 0 then
				local angle, calced_pitch = CalculateAngleAndPitchToPoint({x=px,y=py,z=pz},{x=px,y=py,z=(pz+i)})
				SetAnglePitch(angle, calced_pitch)
				tracing = "Var1.8" 
				return tracing
			end
		end 
	end
	local tracing = "Var2" 
    return tracing 
end

local function NoShapeshift()
	if State == "PAUSE" 
	or State == "FIGHT"
	or State == "IDLE"
	or State == "MOVE"
	or State == "CUSTOM_MOVE"
    or State == "DEAD"
	or State == "OVERLOAD"
	or State == "SENDMAIL"
	or State == "GOtoMAIL" then
        return
    end 
	if Class == "DRUID" then
		local active = GetShapeshiftFormID()
		if active then
			Eval('CastShapeshiftForm(3)','')
			C_Timer.After(2.4, function() 
				if State ~= "PAUSE" then
					NoShapeshift()
				end
			end)
		end
	end
end

local function CheckifHumanMove()
	local lx, ly, lz = ObjectPosition("player")
	C_Timer.After(0.02, function()  
		if FastDistance(lx, ly, lz, px, py, pz) > 0.5 or IsPlayerMoving() then 
			MoveTo(px, py, pz)
		end	   
	end)
end

local function GetEnemiesAtPosition(o)
    local x1, y1, z1 = ObjectPosition(o)
	if not x1 then
		return
	end
	local Units = Objects(5)
	local Enemie = false
	local Elite = false
	local Found = false
	for v,k in pairs(Units) do
        local x2, y2, z2 = ObjectPosition(k)
        local id = ObjectId(k)
        Dynamit = ObjectId(k)
        if UnitIsEnemy(k,"player") and not UnitIsDead(k) and (FastDistance(x1, y1, z1, x2, y2, z2) < Mobrange) and ObjectName(k) ~= "Webbed Ore Deposit" and Dynamit ~= 414597 and Dynamit ~= 220426 then --==  true and not ObjectName(k) == "Webbed Ore Deposit" and not UnitIsDead(k) and FastDistance(x1, y1, z1, x2, y2, z2) < 200 then		
			if AvoidElite then	
				local MobClass = UnitClassification(k)
				if MobClass == "worldboss"
				or MobClass == "rareelite"
				or MobClass == "elite"
				or MobClass == "rare" then
					Elite = true
					tablenumb = table.getn(Blacklist)
					for i = 1, tablenumb do
						if Blacklist[i] == o then
							Found = true
						end
					end
					if Found == false then
						table.insert(Blacklist, o)
						if State == "IDLE" then
							print("Ignore Node. Reason: Elite Mobs are to close. "..ObjectName(k))
						end
						return Enemie, Elite 
					end	
				end
			end
			if AvoidMobs 
			or State == "ITEMUSE"
			or State == "GUILDBANK"
			or State == "REPAIR/SELL" then
				Enemie = true
				tablenumb = table.getn(Blacklist)
				for i = 1, tablenumb do
					if Blacklist[i] == o then
						Found = true
					end
				end
				if Found == false then
					table.insert(Blacklist, o)
					if State == "IDLE" then
						print("Ignore Node. Reason: Mobs are to close. "..ObjectName(k))
					end
					return Enemie, Elite 
				end	
			end
        end
    end
    return Enemie, Elite 
end     

local function Blacklistcheck(Guid)
	tablenumb = table.getn(Blacklist)
	for i = 1, tablenumb do
		if tostring(Blacklist[i]) == tostring(Guid) then
			return true
		end
	end
	return false
end
-- Clear Blacklist --
timer = C_Timer.NewTicker(180, function()
    if State == "PAUSE" then
        return
    end
    for k in pairs (Blacklist) do
        Blacklist[k] = nil
    end 
    for k in pairs (BlacklistedPlace) do
        --BlacklistedPlace[k] = nil
    end 
	LandBlacklistedPlace = {}
    SaveSettings()  
end) 

local function BLPCheck(xk,yk,zk)	
    for v,k in pairs(BlacklistedPlace) do
        local bx,by,bz,br = k[1],k[2],k[3],k[4]
        local distance = FastDistance2D(xk,yk,bx,by)
        if distance < br then
            return true
        end
    end
	for vnb,knb in pairs(LandBlacklistedPlace) do
        local bx,by,bz,br = knb[1],knb[2],knb[3],knb[4]
        local distance = FastDistance2D(xk,yk,bx,by)
        if distance < br then
            return true
        end
    end
	for vw,kw in pairs(WhitelistedPlace) do
        local bx,by,bz,br = kw[1],kw[2],kw[3],kw[4]
        local distance = FastDistance2D(xk,yk,bx,by)
        if distance < br then
            return false
        end
    end
	for vb,kb in pairs(AutoBlacklistedPlace) do
        local bx,by,bz,br = kb[1],kb[2],kb[3],kb[4]
        local distance = FastDistance2D(xk,yk,bx,by)
        if distance < br then
            return true
        end
    end
	local hitx, hity, hitz = TraceLine(xk,yk,(zk+1), xk,yk,(zk+100), hitFlags)
	if hitx ~= 0 and not fishpool then
		--DevTools_Dump("Ignore Node. Reason: Underground, submerged, indoors or not visible from above.")
		table.insert(AutoBlacklistedPlace, {xk,yk,zk, 5})
		return true
	end
    return false
end

local function NodeIgnorCheck(k)
	if warchest then
		return false
	end
	if IgnObj then
        for vv,kk in pairs(nodes) do
			if kk.nid == ObjectId(k) and kk.Chk == true then
                return true
            end
        end 
    end  
    if not ObjectIsOutdoors(k) then
        local px, py, pz = ObjectPosition(k)
		noskip = nil
		for wv,wk in pairs(WhitelistedPlace) do
			local bx,by,bz,br = wk[1],wk[2],wk[3],wk[4]
			local distance = FastDistance2D(px,py, bx,by)
			if distance < br then
				noskip = true
			end
		end
		
		if not noskip then
			table.insert(AutoBlacklistedPlace, {px, py, pz, 5})
			--DevTools_Dump("Ignore Node. Reason: Underground, submerged, indoors or not visible from above.")
			return true
		end
    end 
	if fishpool then
		return false
	end 
	TWWGather = false
    if OnlyTWWGather then        
        for vo, ko in pairs(nodes) do
            if ko.nid == ObjectId(k) then  
                TWWGather = true
            end
        end
        if TWWGather == false then
            return true
        end
    end
    return false    
end
-- Flask --
local function Flask()
	if State == "METAMORPH/EZ-MINE" or State == "GOtoMAIL" then-- or State == "CUSTOM_MOVE" then
		return
	end
	if UnitIsDeadOrGhost("player") 
	or State == "PAUSE" 
	or not NeedFlaskAndItemUse then
		State = "IDLE"
		return
	end
	Chiltime = nil
	chifmv = CheckifHumanMove()
    local Enemie, Elite = GetEnemiesAtPosition("player")
	if IsFlying() and not IsPlayerMoving() and State == "ITEMUSE" and not Enemie then
		local hitx, hity, hitz = TraceLine(px, py, (pz-1), px, py, (pz-100), hitFlags)
		if hitx and FastDistance(hitx, hity, hitz, px, py, pz) < 1 then
			local active = GetShapeshiftFormID()
			if Class == "DRUID" and active then
				NoShapeshift()
			else
				Dismount()
			end
		end
	end
	local active = GetShapeshiftFormID()
	if not MerchantFrame:IsVisible() and State == "ITEMUSE" and not IsFlying() and not Enemie then
		if moving then
			Eval('ToggleAutoRun()','')
			moving = nil
		end
		if Class ~= "DRUID"
		or not active then
		  for i = 1, #items do
			if GetItemCount(items[i],nil,nil,nil) > 0 and not UnitCastingInfo("player") then
				if items[i] == 212308
				or items[i] == 212309
				or items[i] == 212310 then
					itemMinLevel = select(5, GetItemInfo(items[i]))
					if not C_UnitAuras.GetPlayerAuraBySpellID(432265) and UnitLevel("player") >= itemMinLevel and Truesight then
						UseItemByName(items[i])
						NeedFlaskAndItemUse = nil
						State = "IDLE"
						return
					end
				elseif items[i] == 124671 and Firewater then
					startTime, duration, enable = C_Container.GetItemCooldown(items[i])
					if startTime == 0 and not C_UnitAuras.GetPlayerAuraBySpellID(185562) then
						UseItemByName(items[i])
						NeedFlaskAndItemUse = nil
						State = "IDLE"
						return
					end
				elseif items[i] == 212314
				or items[i] == 212315
				or items[i] == 212316 then
					if not C_UnitAuras.GetPlayerAuraBySpellID(432286) and UnitLevel("player") >= itemMinLevel and Bountiful then
						UseItemByName(items[i])
						NeedFlaskAndItemUse = nil
						State = "IDLE"
						return
					end
				elseif items[i] == 191342
				or items[i] == 191343
				or items[i] == 191344 then
					if not C_UnitAuras.GetPlayerAuraBySpellID(371458) and UnitLevel("player") >= itemMinLevel and DFDeft then
						UseItemByName(items[i])
						NeedFlaskAndItemUse = nil
						State = "IDLE"
						return
					end
				elseif items[i] == 191345
				or items[i] == 191346
				or items[i] == 191347 then
					if not C_UnitAuras.GetPlayerAuraBySpellID(371457) and UnitLevel("player") >= itemMinLevel and DFFines then
						UseItemByName(items[i])
						NeedFlaskAndItemUse = nil
						State = "IDLE"
						return
					end
				elseif items[i] == 191354
				or items[i] == 191355
				or items[i] == 191356 then
					if not C_UnitAuras.GetPlayerAuraBySpellID(393715) and UnitLevel("player") >= itemMinLevel and DFPerc then
						UseItemByName(items[i])
						NeedFlaskAndItemUse = nil
						State = "IDLE"
						return
					end
				elseif (items[i] == 222505 and IronRazor)
				or (items[i] == 222506 and IronRazor)
				or (items[i] == 222507 and IronRazor) then
					local gatherer1 = checkProfession(prof1SkillID)
					local enchanted1 = checkEnchant(20)
					local gatherer2 = checkProfession(prof2SkillID)
					local enchanted2 = checkEnchant(23)
					if gatherer1 and not enchanted1 then
						NeedFlaskAndItemUse = nil
						UseItemByName(items[i])
						Eval('UseInventoryItem(20)','')
						C_Timer.After(3.2, function() 
							if State ~= "PAUSE" then
								State = "IDLE"
							end
						end)						
						return
					elseif gatherer2 and not enchanted2 then
						NeedFlaskAndItemUse = nil
						UseItemByName(items[i])
						Eval('UseInventoryItem(23)','')
						C_Timer.After(3.2, function() 
							if State ~= "PAUSE" then
								State = "IDLE"
							end
						end)
						return
					end
				elseif items[i] == 194062
				or items[i] == 194039
				or items[i] == 200678
				or items[i] == 200677
				or items[i] == 224752
				or items[i] == 201300
				or items[i] == 201301
				or items[i] == 202011
				or items[i] == 202014 
				or items[i] == 224583
				or items[i] == 224838
				or items[i] == 224264
				or items[i] == 224835
				or items[i] == 224584
				or items[i] == 224265
				or items[i] == 224818
				or items[i] == 224817 then
					if not ItemnotUsable(items[i]) and KPoints then
						ItemName = select(1, GetItemInfo(items[i]))
						NeedFlaskAndItemUse = nil
						UseItemByName(items[i])
						C_Timer.After(1.6, function() 
							if State ~= "PAUSE" then
								State = "IDLE"
							end
						end)
						return
					end
				elseif items[i] == 204911
				or items[i] == 204911 then					
					ItemName = select(1, GetItemInfo(items[i]))
					UseItemByName(items[i])
					NeedFlaskAndItemUse = nil
					State = "IDLE"
					return
				end
			end
		  end
		  C_Timer.After(1, function() 
			if State ~= "PAUSE" then
				State = "IDLE"
			end
		  end)
		else
			NoShapeshift()
			C_Timer.After(2.6, function() 
				if State ~= "PAUSE" then
					Flask()
				end
			end)
		end
	else
		if State ~= "PAUSE" and State ~= "CUSTOM_MOVE" then
			NeedFlaskAndItemUse = nil
			State = "IDLE"
		end
	end		
end
-- Node visible check
local function NodVisCheck()
	if State == "PAUSE" 
	or State == "FIGHT"
	or State == "ITEMUSE"
	or State == "HEARTSTONE"
	or State == "GUILDBANK"
	or State == "REPAIR/SELL"
    or State == "DEAD"
	or State == "SPORE"
	or State == "OVERLOAD"
	or State == "METAMORPH/EZ-MINE"
	or State == "SENDMAIL"
	or State == "GOtoMAIL"
	or State == "FISHING"
	or State == "SPOTFISHING"
	or State == "CHARGEVIGOR"
	or warchest then
		Chiltime = nil
		C_Timer.After(0.2, NodVisCheck)
        return
    end 
    if x and tarobject then 
		local Lootdistance = FastDistance(px, py, pz, x, y, z)
		if Lootdistance <= 4  and not UnitCastingInfo("player") and not IsFlying() and not IsPlayerMoving() then
			if not Chiltime then
				Chiltime = GetTime()
			elseif (Chiltime + 4) < GetTime() then
				DevTools_Dump("Ignore Node. Reason: Gathering takes too long.")
				table.insert(Blacklist, tarobject)
				Chiltime = nil
				tarobject = nil
				x,y,z = nil,nil,nil
				if State ~= "PAUSE" and State ~= "CUSTOM_MOVE" then
					State = "IDLE"
				end
			end
		else 
			Chiltime = nil
		end
	end
	C_Timer.After(0.2, NodVisCheck)
end
NodVisCheck()
-- SPORE
local function Spore()
	if State == "SPORE" then
		local active = GetShapeshiftFormID()
		if not IsMounted() and not UnitCastingInfo("player") then	
			if Druid then
				if not active then	
					Eval('CastShapeshiftForm(3)', "")
				elseif active and active ~= 27 then
					if active ~= 4 then
						Eval('CastShapeshiftForm(3)', "") 
					end
					JumpOrAscendStart()
					--waterjump()
					C_Timer.After(3, function() Eval('AscendStop()',"") end)
				end
			end
			if not Druid and not IsMounted() then
				if active and Class == "DRUID" then
					Eval('CastShapeshiftForm(2)', "")
				end
				chifmv = CheckifHumanMove()
				C_MountJournal.SummonByID(0)
			end	
		end
		if IsMounted() or active == 27 then
			local Units = Objects(5)
			for v,k in pairs(Units) do
				if ObjectId(k) == 203919 then
					local xs, ys, zs = ObjectPosition(k)
					local angle, calced_pitch = CalculateAngleAndPitchToPoint({x=px,y=py,z=pz},{x=xs,y=ys,z=zs})
					SetAnglePitch(angle, calced_pitch)
					if not moving then
						Eval('ToggleAutoRun()',"")
						moving = true
					end
					C_Timer.After(0.05, Spore)
					return
				end
			end
			if moving then
				Eval('ToggleAutoRun()',"")
				moving = nil
			end
		end
		C_Timer.After(0.05, Spore)
	end	
end

local function SpeedyLooting(tablenumb,pathIndex)				
	if pathIndex >= tablenumb 
	or State ~= "METAMORPH/EZ-MINE" then
		print("no chunk")
		Speedy = nil
		Lastloot = GetTime()
		SpeedyLootTableRow = {}
		SpeedyLootTable = {}
		State = "IDLE"
		return
	end
	if (GetTime() * 1000) <= castendsoll
	or UnitCastingInfo('player')
	or IsPlayerMoving() then
	--or (castfail and (castfail > caststart) and ((castfail* 1000) < castendsoll))
	-- (Lastloot and castfail and (Lastloot < castend) and (Lastloot > SpeedyTime) and (Lastloot > castfail) and ((Lastloot * 1000) < (castendsoll + 500))) then
		print("not ready")
		--C_Timer.After(0.1, function() 
			--SpeedyLooting(tablenumb,pathIndex)
			--return
		--end)
	else
		lastcastend = castendsoll
		if pathIndex == 0 then
			pathIndex = pathIndex + 1
		end
		kok = SpeedyLootTable[pathIndex]
		--print(kok)
		if ObjectDistance(kok, "player") and (ObjectDistance(kok, "player") <= 15) then
			print("interract")
			--print(kok)
			ObjectInteract(kok)
			C_Timer.After(0.7, function() 
				pathIndex = pathIndex + 1
				SpeedyLooting(tablenumb,pathIndex)
			end)
			return
		end
	end
	if State ~= "PAUSE" then				
		C_Timer.After(0.7, function() 
			SpeedyLooting(tablenumb,pathIndex)
		end)
	end
end

-- Metamorph
local function compare(a,b)
	return a[2] < b[2]
end

local function Metamorph()
	if State == "METAMORPH/EZ-MINE" and not Speedy then
		splitfound = false
		local objects = Objects(8)
		local xs, ys, zs = nil, nil, nil
		local Shortdist
		local distance
		local kok = nil
		for v,k in pairs(objects) do
			if ObjectLootable(k)
			and Blacklistcheck(k) ~= true
			and NodeIgnorCheck(k) ~= true
			and (ObjectId(k) == 398747
				or ObjectId(k) == 381479
				or ObjectId(k) == 434556
				or ObjectId(k) == 434557
				or ObjectId(k) == 434558) then
				splitfound = true
				local Enemie, Elite
				if AvoidMobs then
					Enemie,_ = GetEnemiesAtPosition(k)
				else 
					Enemie = false
				end
				if AvoidElite then
					_, Elite = GetEnemiesAtPosition(k)
				else 
					Elite = false
				end
				
				if Enemie == false
				and Elite == false	then
					local xd, yd, zd = ObjectPosition(k)					
					distance = FastDistance(px, py, pz, xd, yd, zd)
					if not Shortdist then
						Shortdist = distance
						xs, ys, zs = xd, yd, zd
						kok = k
					elseif Shortdist and distance < Shortdist then
						Shortdist = distance
						xs, ys, zs = xd, yd, zd
						kok = k
					end
					
				end	
				table.insert(SpeedyLootTableRow, {k , distance})			
			end			
		end
		if table.getn(SpeedyLootTableRow) > 0 then
			table.sort(SpeedyLootTableRow, compare)
			for v,k in pairs (SpeedyLootTableRow) do
				table.insert(SpeedyLootTable, k[1])
			end 
			kok1 = SpeedyLootTable[1]
			table.insert(SpeedyLootTable, kok1)	
		end
		if LoadExpansion == "The War Within" and not Speedy then		
			local tablenumb = table.getn(SpeedyLootTable)
			if tablenumb == 0 then
				C_Timer.After(0.2, Metamorph)
				return
			end
			print(tablenumb-1)
			local pathIndex = 0
			Speedy = true
			SpeedyTime = GetTime()
			SpeedyLooting(tablenumb,pathIndex)
			return			
		end
		if xs and kok and LoadExpansion == "Dragonflight" then
			local Lootdistance = FastDistance(px, py, pz, xs, ys, zs)
			if not UnitCastingInfo("player") then
				if Lootdistance >= 6 then				
					local angle, calced_pitch = CalculateAngleAndPitchToPoint({x=px,y=py,z=pz},{x=xs,y=ys,z=zs})
					if calced_pitch < (-1) then
						SetPitch(calced_pitch+(-0.1))
						SendMovementHeartbeat()
					elseif calced_pitch > (-0.5) or calced_pitch < 0.5 then
						if Lootdistance <= 15 then 
							SetPitch(calced_pitch+(-0.15))
							SendMovementHeartbeat()
						else
							SetPitch(calced_pitch)
							SendMovementHeartbeat()
						end
					end
					if Human then
						FaceDirection(angle, true)				
					else
						FaceDirection((angle % (2*math.pi)), false)
						SendMovementHeartbeat() 
					end
					if not moving then
						Eval('ToggleAutoRun()',"")
						moving = true
						C_Timer.After(0.2, Metamorph)
						return
					end
				else
					if moving then
						Eval('ToggleAutoRun()',"")
						moving = nil
					end
					ObjectInteract(kok)
					C_Timer.After(0.2, Metamorph)
					return
				end
			end
			C_Timer.After(0.2, Metamorph)
			return
		end
		if moving then
			Eval('ToggleAutoRun()',"")
			moving = nil
		end
		if SearchSplitt == false and splitfound == false then
			State = "IDLE"
			for k in pairs (SpeedyLootTable) do
				SpeedyLootTable[k] = nil
			end 
			return
		end
		C_Timer.After(0.2, Metamorph)
	end	
end
-- fishing --


local function SpotFishi()	
	local success, result = pcall(function()
		if State ~= "SPOTFISHING" then
			return
		end
		if UnitAffectingCombat("player") and FightMobs then
			State = "FIGHT"
			return
		end
		if UnitAffectingCombat("player") and not FightMobs then							
			foundpoollandplace = nil
			table.insert(Blacklist, fishpoolobj)
			fishpoolobj = nil
			State = "IDLE"
			return
		end
		if not UnitCastingInfo("player") and not UnitChannelInfo("player") then
			if not LetGhoul then
				local numBags = 5
				for i = 0, numBags do
					local numBagSlots = C_Container.GetContainerNumSlots(i)
					for j = 0, numBagSlots do
						local itemID = C_Container.GetContainerItemID(i, j)				
						if itemID == 220152 then
							ItemName = select(1, C_Item.GetItemInfo(itemID))
							UseItemByName(ItemName)					
						end
					end	
				end
			end
            Eval('CastSpellByID(131474)',"")
        end
        local Obj = Objects(8)
        for v,o in pairs(Obj) do
            local id = ObjectId(o)
            if id == 35591 then
                if tostring(ObjectCreator(o)) == tostring(UnitGUID("player")) then
                    _,bis,_ = ObjectFlags(o)
                    if bis == 1 then
                        ObjectInteract(o)
                    end
                end
            end	
        end
		C_Timer.After(1, SpotFishi)
	end)
	if success then
	  
	else
	   print("SpotFish"..result)
	end	
end


local function Fishi()
	--print(fishpool)
	local success, result = pcall(function()
		if State == "FISHING" and x then 
			if UnitAffectingCombat("player") and FightMobs then
				State = "FIGHT"
				return
			end
			if IsSwimming() then
				foundpoollandplace = nil
				tarobject = nil
				fishpool = nil
				fishpoolobj = nil
				xxp,yyp,zzp = nil, nil, nil
				State = "IDLE"
				return
			end
			if UnitAffectingCombat("player") and not FightMobs then							
				foundpoollandplace = nil
				table.insert(Blacklist, fishpoolobj)
				fishpoolobj = nil
				fishpool = nil
				tarobject = nil
				xxp,yyp,zzp = nil, nil, nil
				foundpoollandplace = nil
				State = "IDLE"
				return
			end
			local plx, ply, plz = ObjectPosition(fishpoolobj)
			if ObjectLootable(fishpoolobj) then 
				local Enemie, Elite = GetEnemiesAtPosition("player")
				if Enemie or Elite then
					print("Blacklist pool")					
					table.insert(LandBlacklistedPlace, {plx, ply, plz, 3})
					fishpool = nil
					tarobject = nil
					fishpoolobj = nil
					xxp,yyp,zzp = nil, nil, nil
					foundpoollandplace = nil
					State = "IDLE"
					return
				end
				if not ObjectDistance(fishpoolobj, "player") or (ObjectDistance(fishpoolobj, "player") <= 10) then
					foundpoollandplace = nil
					State = "IDLE"
					return
				end
				local Lootdistance = FastDistance(px, py, pz, x, y, z)
				if Lootdistance >= 2  and not UnitCastingInfo("player") and not UnitChannelInfo("player") and not IsPlayerMoving() then
					State = "MOVETO"
					Unstuck = true
					MoveTo(x,y,z)
					C_Timer.After(0.9, function() 
						if FastDistance(px, py, pz, x, y, z) < 2 then
							if State ~= "PAUSE" then
								State = "FISHING"
							end							
						else
							if State ~= "PAUSE" then
								foundpoollandplace = nil
								State = "IDLE"
							end
						end
						Unstuck = false
					end)
				end
				if Lootdistance <= 2  and not UnitCastingInfo("player") and not UnitChannelInfo("player") then
					local angle, calced_pitch = CalculateAngleAndPitchToPoint({x=px,y=py,z=pz},{x=plx,y=ply,z=plz}) 
					local DirCurr = ObjectRotation('player')
					local XXD, YYD, ZZD = RotateVector(px, py, pz, DirCurr, 5)
					local actangle, _ = CalculateAngleAndPitchToPoint({x=px,y=py,z=pz},{x=XXD,y=YYD,z=ZZD}) 
					if (angle-actangle) < (-0.03) or (angle-actangle) > (0.03) then
						FaceDirection(angle, true)
					else
						if not LetGhoul then
							local numBags = 5
							for i = 0, numBags do
								local numBagSlots = C_Container.GetContainerNumSlots(i)
								for j = 0, numBagSlots do
									local itemID = C_Container.GetContainerItemID(i, j)				
									if itemID == 220152 then
										ItemName = select(1, C_Item.GetItemInfo(itemID))
										UseItemByName(ItemName)					
									end
								end	
							end
						end
						Eval('CastSpellByID(131474)',"")
					end
				end
				local Obj = Objects(8)
				for v,o in pairs(Obj) do
					local id = ObjectId(o)
					if id == 35591 then
						if tostring(ObjectCreator(o)) == tostring(UnitGUID("player")) then
							if ObjectDistance(tarobject, o) and (ObjectDistance(tarobject, o) < 3) then
								_,bis,_ = ObjectFlags(o)
								if bis == 1 then
									ObjectInteract(o)
								end
							else
								Eval('CastSpellByID(131474)',"")
							end
						end
					end
				end	
			else				
				fishpool = nil
				tarobject = nil
				fishpoolobj = nil
				foundpoollandplace = nil
				xxp,yyp,zzp = nil, nil, nil
				State = "IDLE"
			end
		end
	end)
	if success then
	  
	else
	   print("Fish"..result)
	end
	C_Timer.After(1, Fishi)
end
Fishi()

-- Scan--	
local function scan()
    if State == "PAUSE"
	or State == "FIGHT"
	or State == "INN"
	or State == "FISHING"
	or State == "SPOTFISHING"
	or State == "ITEMUSE"
	or State == "HEARTSTONE"
	or State == "GUILDBANK"
	or State == "REPAIR/SELL"
	or State == "SENDMAIL"
	or State == "GOtoMAIL"
	or State == "METAMORPH/EZ-MINE"
	or State == "CHARGEVIGOR"
	or State == "SPORE"
	or State == "CUSTOM_MOVE"
    or State == "DEAD" 
	or UnitCastingInfo("player") then
        return
    end
	--State = "SCAN"
	PoolFishing = true
    Shortdist = nil 
	LastPrio = nil
    tarobject = nil 
	fishpoolobj = nil
	xxp,yyp,zzp = nil, nil, nil
	foundpoollandplace = nil
	foundlandplace = nil
    Lootdistance = nil
	INTERRUPTED = 0
	NoLOS = nil
	IgnoreHigh = nil
    if not xfp and LoadUi then
        NextPoint()
        return
    end	
	local ObjectsSorted = {}
    local objects = Objects(8)    
	if PrioObj then
		for ov,ok in pairs(objects) do
			oPrio = 10
			for pv,pk in pairs(PrioObj) do
				if ObjectName(ok) == pk[1] then     
					oPrio = pk[2]							
				end
			end
			table.insert(ObjectsSorted, {ok , oPrio})
		end
		table.sort(ObjectsSorted, compare)
		--for rv,rk in pairs (ObjectRow) do
			--table.insert(objectsSorted, rk[1])
		--end 
	else
		for ov1,ok1 in pairs(objects) do			
			table.insert(ObjectsSorted, {ok1 , 10})
		end
	end 
    for v,k in pairs(ObjectsSorted) do		
		if not Mailbox and GameObjectType(k[1])==19 then
			Mailbox = k[1] 
			mx,my,mz = ObjectPosition(k[1])
		end
		if onlyspotfish then
			return
		end
		fishpool = nil
		IgnoreHigh = nil
		if GameObjectType(k[1])==25 and not IgnoreTWWf then
			if Blacklistcheck(ObjectGUID(k[1])) == false and NodeIgnorCheck(k[1]) == false and BLPCheck(ObjectPosition(k[1])) == false then
				fishpool = true --CheckFishPool(k[1])
				if ObjectId(k[1]) == 451678 or ObjectId(k[1]) == 451681 then
					IgnoreHigh = true
				end	
			end
		end
		warchest = nil
		if GameObjectType(k[1])==10 and ObjectId(k[1]) == 290129 and not IgnWarChest then
			warchest = true
		elseif GameObjectType(k[1])==3 and not IgnWarChest then
			if ObjectId(k[1]) == 385217 or ObjectId(k[1]) == 433370 or ObjectId(k[1]) == 433369 or ObjectId(k[1]) == 324044 or ObjectId(k[1]) == 290134
			or ObjectId(k[1]) == 385216 or ObjectId(k[1]) == 324050 or ObjectId(k[1]) == 324042 or ObjectId(k[1]) == 327650 or ObjectId(k[1]) == 324051
			or ObjectId(k[1]) == 324040 or ObjectId(k[1]) == 324053 or ObjectId(k[1]) == 324041 or ObjectId(k[1]) == 302749 or ObjectId(k[1]) == 327652
			or ObjectId(k[1]) == 302748 or ObjectId(k[1]) == 324052 or ObjectId(k[1]) == 290135 or ObjectId(k[1]) == 324049 or ObjectId(k[1]) == 324043 then
				warchest = true
			end
		end
		if ObjectLootable(k[1])
		and (GameObjectType(k[1])==50 or warchest or fishpool) 
		and Blacklistcheck(ObjectGUID(k[1])) == false
		and NodeIgnorCheck(k[1]) == false
		and BLPCheck(ObjectPosition(k[1])) == false
		and ObjectId(k[1]) ~= 443754 
		and ObjectId(k[1]) ~= 439338 then
			local Enemie, Elite
			local HerbMineFish = false
			AvoidMobs = false
			AvoidElite = false
			Mobrange = 0
			for av,ak in pairs(nodes) do
				if ak.nid == ObjectId(k[1]) and ak.Art == "h" then 
					HerbMineFish = true
					AvoidMobs = HAvoidMobs 
					AvoidElite = HAvoidElite 
					Mobrange = HMobrange
				elseif ak.nid == ObjectId(k[1]) and ak.Art == "m" then
					HerbMineFish = true
					AvoidMobs = MAvoidMobs 
					AvoidElite = MAvoidElite 
					Mobrange = MMobrange
				elseif ak.nid == ObjectId(k[1]) and ak.Art == "f" then
					HerbMineFish = true
					AvoidMobs = FAvoidMobs 
					AvoidElite = FAvoidElite 
					Mobrange = FMobrange
				end
			end
			if HerbMineFish == false then
				AvoidMobs = TAvoidMobs 
				AvoidElite = TAvoidElite 
				Mobrange = TMobrange
			end
			if AvoidMobs then
				Enemie,_ = GetEnemiesAtPosition(k[1])
			else 
				Enemie = false
			end
			if AvoidElite then
				_, Elite = GetEnemiesAtPosition(k[1])
			else 
				Elite = false
			end
			
			if Enemie == false
			and Elite == false	then 
				local xk,yk,zk = ObjectPosition(k[1])
				CheckFarmDist = FastDistance2D(px, py, xk, yk) 
				if (CheckFarmDist < tonumber(Gatherrange))  and ((zk <(pz + 90)) and (zk >(pz - 90)) or IgnoreHigh or IgnoreGHigh) then					
					local hx, hy, hz = TraceLine(px, py, (pz+0.05), xk,yk,zk+1, hitFlags)
					if hx ~= 0 then
						NoLOS = true
						if pz < zk then
							thz = zk+50
						else
							thz = pz+50
						end
						local thpx, thpy, thpz = TraceLine(px, py, (pz+0.05), px, py, thz, hitFlags)
						if thpx == 0 then
							thpz = thz
						end
						local thnx, thny, thnz = TraceLine(xk, yk, (zk+1), xk, yk, thz, hitFlags)
						if thnz == 0  then
							thnz = thz
						end
						Variant = TrLiPlayerToNode(px, py, pz, thpz, xk, yk, zk, thnz)
						if Variant ~= "Var2" then
							local distance = ObjectDistance('player', k[1])
							if not Shortdist then
								Shortdist = distance
								LastPrio = k[2]
								tarobject = k[1]
								if fishpool then
									fishpoolobj = k[1]
								end
							elseif Shortdist and distance < Shortdist then
								if NoPrio and distance < NoPrioRange then 
									Shortdist = distance
									LastPrio = k[2]
									tarobject = k[1]
									if fishpool then
										fishpoolobj = k[1]
									end
								elseif k[2] <= LastPrio then
									Shortdist = distance
									LastPrio = k[2]
									tarobject = k[1]
									if fishpool then
										fishpoolobj = k[1]
									end
								end
							end	
						end
					else
						local distance = ObjectDistance('player', k[1])
						if not Shortdist then
							if NoLOS then
								NoLOS = nil
							end
							Shortdist = distance
							LastPrio = k[2]
							tarobject = k[1]
							if fishpool then
								fishpoolobj = k[1]
							end
						elseif Shortdist and distance < Shortdist then
							if NoLOS then
								NoLOS = nil
							end
							if NoPrio and distance < NoPrioRange then 
								Shortdist = distance
								LastPrio = k[2]
								tarobject = k[1]
								if fishpool then
									fishpoolobj = k[1]
								end
							elseif k[2] <= LastPrio then
								Shortdist = distance
								LastPrio = k[2]
								tarobject = k[1]
								if fishpool then
									fishpoolobj = k[1]
								end
							end
						end
					end
				end
			end
		end
    end
	if tarobject then		
		local guid = tarobject
		if fishpoolobj and fishpoolobj ~= tarobject then
			fishpoolobj = nil
		end
		if (State == "IDLE" or State == "MOVE") then 
			lastguid = guid
			x, y, z = ObjectPosition(tarobject)
			if not NoLOS then
				local angle, calced_pitch = CalculateAngleAndPitchToPoint({x=px,y=py,z=pz},{x=x,y=y,z=z})
				SetAnglePitch(angle, calced_pitch)
			end
			State = "IDLE"
			return
		else
			tarobject = nil
			fishpool = nil
			fishpoolobj = nil
		end
	end
    if not tarobject and State ~= "MOVE" and State ~= "CUSTOM_MOVE" then
		if fishpoolobj then
			fishpoolobj = nil
		end
		x,y,z = nil, nil, nil
        State = "MOVE" 
        if ((FastDistance2D(px, py, xfp,yfp) < rfp) or (LastPoint == CountPoints)) then 
			NextPoint()  
        else
			LastPoint = nil
			NextPoint()
        end 
    end
end
-- nodecheck
local function nodecheck()
	local success, result = pcall(function()
		if UnitIsDeadOrGhost("player") then 
			return 
		end 
		if State == "PAUSE" 
		or State == "FIGHT"
		or State == "INN"
		or State == "FISHING"
		or State == "SPOTFISHING"
		or State == "HEARTSTONE"
		or State == "GUILDBANK"
		or State == "REPAIR/SELL"
		or State == "DEAD"
		or State == "CHARGEVIGOR"
		or State == "AVOID"
		or State == "CUSTOM_MOVE"
		or State == "GOtoMAIL"
		or State == "SENDMAIL"
		or State == "SPORE"
		or State == "METAMORPH/EZ-MINE"
		or State == "ITEMUSE" 
		or UnitCastingInfo("player")
		or State == "FLEE" then
			return
		end
		if State == "IDLE"
		or State == "MOVE" 
		or State == "CAN_GATHER_START"
		or State == "GATHER_START" then
			if tarobject and x
			and Blacklistcheck(tarobject) ~= true
			and BLPCheck(x,y,z) == false then
				local objects = Objects(8) 
				for v,k in pairs(objects) do
					if lastguid and tostring(ObjectGUID(k)) == tostring(lastguid)  and ObjectLootable(k) then
						--print("Lastguid Alive") 
						return
					end
				end
			else
				--tarobject = nil
			end
			scan()
		end
	end)
	if success then
	  
	else
	   print("NoCh"..result)
	end
	C_Timer.After(0.1, nodecheck)
end
nodecheck()
local function awoid()
	if UnitCastingInfo("player") then
		return
	end
	State = "AWOID"	
    Unstuck = true
	x, y, z = nil, nil, nil
	if tarobject then
		--table.insert(Blacklist, tarobject)
		--tarobject = nil
		--x,y,z = nil,nil,nil
		--State = "IDLE"
	end
	if Human then
		FaceDirection((ObjectRotation('player') + math.rad(180)),true)
	else
		FaceDirection(((ObjectRotation('player') + math.rad(180))% (2*math.pi)),false)
		SendMovementHeartbeat() 
	end
    JumpOrAscendStart()
	if not SteadyFly then
		C_Timer.After(0.1, function() 
			JumpOrAscendStart()
		end) 
	end
	Eval('MoveForwardStart()',"")
	C_Timer.After(1, function() 
		Eval('MoveForwardStop()',"")
		Eval('AscendStop()',"")
		Unstuck = false
		if State ~= "PAUSE" then
			State = "IDLE"
		end
		--scan()
	end)        
end
--Flask Check
local function FlaskCheck()
	local success, result = pcall(function()
		if UnitIsDeadOrGhost("player")
		or State == "PAUSE" 
		or State == "INN"
		or State == "FISHING"
		or State == "CHARGEVIGOR"
		or State == "SPOTFISHING"
		or State == "HEARTSTONE"
		or State == "GUILDBANK"
		or State == "REPAIR/SELL"
		or State == "DEAD"
		or State == "GOtoMAIL"
		or State == "SENDMAIL"
		or State == "SPORE"
		or State == "METAMORPH/EZ-MINE"
		or State == "FLEE" then
			return
		end
		for i = 1, #items do
		itemMinLevel = select(5, GetItemInfo(items[i]))
		FlaskAndItem = GetItemCount(items[i],nil,nil,nil)	
			if FlaskAndItem > 0 then
				if items[i] == 212308
				or items[i] == 212309
				or items[i] == 212310 then
					if not C_UnitAuras.GetPlayerAuraBySpellID(432265) and UnitLevel("player") >= itemMinLevel and Truesight then
						NeedFlaskAndItemUse = true
						return
					end
				elseif items[i] == 212314
				or items[i] == 212315
				or items[i] == 212316 then
					if not C_UnitAuras.GetPlayerAuraBySpellID(432286) and UnitLevel("player") >= itemMinLevel and Bountiful then
						NeedFlaskAndItemUse = true
						return
					end
				elseif items[i] == 191342
				or items[i] == 191343
				or items[i] == 191344 then
					if not C_UnitAuras.GetPlayerAuraBySpellID(371458) and UnitLevel("player") >= itemMinLevel and DFDeft then
						NeedFlaskAndItemUse = true
						return
					end
				elseif items[i] == 191345
				or items[i] == 191346
				or items[i] == 191347 then
					if not C_UnitAuras.GetPlayerAuraBySpellID(371457) and UnitLevel("player") >= itemMinLevel and DFFines then
						NeedFlaskAndItemUse = true
						return
					end
				elseif items[i] == 191354
				or items[i] == 191355
				or items[i] == 191356 then
					if not C_UnitAuras.GetPlayerAuraBySpellID(393715) and UnitLevel("player") >= itemMinLevel and DFPerc then
						NeedFlaskAndItemUse = true
						return
					end
				elseif (items[i] == 222505 and IronRazor)
				or (items[i] == 222506 and IronRazor)
				or (items[i] == 222507 and IronRazor) then
					local gatherer1 = checkProfession(prof1SkillID)
					local enchanted1 = checkEnchant(20)
					local gatherer2 = checkProfession(prof2SkillID)
					local enchanted2 = checkEnchant(23)
					if gatherer1 and not enchanted1 then
						NeedFlaskAndItemUse = true
						return
					elseif gatherer2 and not enchanted2 then
						NeedFlaskAndItemUse = true
						return
					end
				elseif items[i] == 124671 and Firewater then
					startTime, duration, enable = C_Container.GetItemCooldown(items[i])
					if startTime == 0 and not C_UnitAuras.GetPlayerAuraBySpellID(185562) then
							NeedFlaskAndItemUse = true
						return
					end
				elseif items[i] == 194062
				or items[i] == 194039
				or items[i] == 200678
				or items[i] == 200677
				or items[i] == 224752
				or items[i] == 201300
				or items[i] == 201301
				or items[i] == 202011
				or items[i] == 202014 
				or items[i] == 224583
				or items[i] == 224838
				or items[i] == 224264
				or items[i] == 224835
				or items[i] == 224584
				or items[i] == 224265
				or items[i] == 224818 
				or items[i] == 224817 then
					if not ItemnotUsable(items[i]) and KPoints then
						NeedFlaskAndItemUse = true
						return
					end
				elseif items[i] == 204911
				or items[i] == 204911 then					
					NeedFlaskAndItemUse = true
					return					
				end
			end
		end
		NeedFlaskAndItemUse = nil
	end)
	if success then
	  
	else
	   print("FlCh"..result)
	end
	C_Timer.After(3, FlaskCheck)
end
FlaskCheck()
-- node too close to liquid check --
local function TooCloseToLiquid()	
	local success, result = pcall(function()
		if fishpool then
			return
		end
		if State == "GATHER_START"
		or State == "CAN_GATHER_START" then
			if not UnitCastingInfo("player") then
				return
			end
		end
		tablenumb = table.getn(Blacklist)
		local hx, hy, hz = TraceLine(px, py, pz, px, py, (pz-1), 0x10000)
		if hx ~= 0 and tarobject and FastDistance(px, py, pz, x, y, z) < 1 then
			xk,yk,zk = ObjectPosition(tarobject)
			noskip = nil
			for v,k in pairs(WhitelistedPlace) do
				local bx,by,bz,br = k[1],k[2],k[3],k[4]
				local distance = FastDistance2D(xk,yk, bx,by)
				if distance < br then
					noskip = true
				end
			end
			if not noskip then
				DevTools_Dump("Ignore Node. Reason: Node is too close to liquid. Put node position on whitelist to still collect nodes here.")
				table.insert(AutoBlacklistedPlace, {xk,yk,zk, 3})
				tarobject = nil
				x,y,z = nil,nil,nil
				scan()
			end
		end
	end)
	if success then
	  
	else
	   print("ToClToLi"..result)
	end
	C_Timer.After(1, TooCloseToLiquid)
end
--TooCloseToLiquid()

-- Find and use Mailbox
local function FindMailBox()	
	local success, result = pcall(function()
		if (ObjectMovementFlag('player') == Flags.DESCENDING or ObjectMovementFlag('player') == Flags.NONE)
		and (State == "GOtoMAIL" or State == "SENDMAIL") then --or State == "MOVE" 
			local objects = Objects(8) 
			for v,k in pairs(objects) do				
				if GameObjectType(k)==19 then
					local pmx,pmy,pmz = ObjectPosition(k)
					local Maildistance = FastDistance(px, py, pz, pmx,pmy,pmz)
					if Maildistance <= 6 then 
						chifmv = CheckifHumanMove()
						C_Timer.After(0.25, function()
							if State ~= "PAUSE" then
								ObjectInteract(k)
							end
						end)
					end
				end
			end
		end
	end)
	if success then
	  
	else
	   print("FiMaBo"..result)
	end
	C_Timer.After(0.5, FindMailBox)
end
FindMailBox() 
--flightreadycheck
local function flightreadycheck()
	local success, result = pcall(function()
		if State == "PAUSE"
		or State == "FISHING"
		or State == "SPOTFISHING"
		or State == "FIGHT"
		or State == "HEARTSTONE"
		or State == "INN"
		or State == "GUILDBANK"
		or State == "REPAIR/SELL"
		or State == "SPORE"
		or State == "METAMORPH/EZ-MINE"
		or State == "OVERLOAD"
		or State == "SENDMAIL"
		or State == "ITEMUSE"
		or State == "CAN_GATHER_START"
		or State == "GATHER_START"
		or State == "DEAD"
		or UnitCastingInfo("player")
		or SearchSplitt == true then
			return
		end
		if C_UnitAuras.GetPlayerAuraBySpellID(404468) then
			SteadyFly = true
		else
			SteadyFly = false
		end
		local Vigor = C_UIWidgetManager.GetFillUpFramesWidgetVisualizationInfo(4460).numFullFrames
		local isGliding, canGlide, forwardSpeed = C_PlayerInfo.GetGlidingInfo()
		if isGliding == true and Vigor < 1 and forwardSpeed < 10 then
			if State ~= "CHARGEVIGOR" and State ~= "JUMP" then
				laststate = State
			end	
			State = "CHARGEVIGOR"
			SetPitch(-1.5)
			SendMovementHeartbeat()
			C_Timer.After(20, function() 
				if State ~= "PAUSE" then
					State = laststate
				end				
			end)
		end
		if isGliding == false and State == "CHARGEVIGOR" then
			chifmv = CheckifHumanMove()
		end
		local active = GetShapeshiftFormID()
		if Druid then
			if not active and (State == "IDLE" or State == "MOVE" or State == "GOtoMAIL" or State == "CUSTOM_MOVE") then	
				Eval('CastShapeshiftForm(3)',"")  
			elseif active and active ~= 27 and (State == "IDLE" or State == "MOVE" or State == "GOtoMAIL" or State == "CUSTOM_MOVE") then
				if active ~= 4 then
					Eval('CastShapeshiftForm(3)',"")  
				end
				JumpOrAscendStart()
				waterjump()
				C_Timer.After(3, function() Eval('AscendStop()',"") end)
			end
		end
		if not Druid and not IsMounted() then
			if active and Class == "DRUID" then
				Eval('CastShapeshiftForm(2)',"")  
			end
			chifmv = CheckifHumanMove()
			C_MountJournal.SummonByID(0)
		end	
		if SteadyFly == true and (IsMounted() or (GetShapeshiftFormID() == 27)) then
			if Lootdistance and Lootdistance <= 7 then
				return
			end
			if Targetdistance and Targetdistance <= 7 then
				return
			end
			if not IsFlying() or (IsSwimming() and not IsFlying()) then 
				JumpOrAscendStart()
				StatetoBack = State
				--State = "SKY"
				C_Timer.After(1, function() Eval('AscendStop()','') end)--State = StatetoBack end)
			elseif not IsPlayerMoving() then
				Eval('ToggleAutoRun()','')
			end
		end
	end)
	if success then
	  
	else
	   print("FlReCh"..result)
	end
	C_Timer.After(1, flightreadycheck)
end
flightreadycheck()
-- overload ready check
local function OverloadReadyCheck()
	local success, result = pcall(function()
		OrbOverSpellCheck = C_Spell.GetSpellCharges(423394)
		DFOrbOverSpellCheck = C_Spell.GetSpellCooldown(388213)
		HerbOverSpellCheck = C_Spell.GetSpellCharges(423395)
		DFHerbOverSpellCheck = C_Spell.GetSpellCooldown(390392)
		DFMinisUsable, DFstartOre, _, _  = DFOrbOverSpellCheck.isEnabled , DFOrbOverSpellCheck.startTime
		DFHerbisUsable, DFstartHerb, _, _  = DFHerbOverSpellCheck.isEnabled , DFHerbOverSpellCheck.startTime
		if OrbOverSpellCheck.currentCharges > 0 then
			CanOverloadMining = true
		else
			CanOverloadMining = false
		end
		if DFMinisUsable and DFstartOre == 0 then
			CanOverloadDFMining = true
		else
			CanOverloadDFMining = false
		end
		if HerbOverSpellCheck.currentCharges > 0 then
			CanOverloadHerb = true
		else
			CanOverloadHerb = false
		end
		if DFHerbisUsable and DFstartHerb == 0 then
			CanOverloadDFHerb = true
		else
			CanOverloadDFHerb = false
		end
	end)
	if success then
	  
	else
	   print("OvReCh"..result)
	end
	C_Timer.After(5, OverloadReadyCheck)
end
OverloadReadyCheck()

local function PurchaseRank4KP(SkillLine,KPNodeID)
    configID = C_ProfSpecs.GetConfigIDForSkillLine(SkillLine)
    --local nodeID = 59701 --59651 

    if not configID then 
		print("Knowledge Points not distributed. SkillLine?")
		return 
	end
	--for i = 1, 5 do
		local nodeInfo = C_Traits.GetNodeInfo(configID, KPNodeID)--59572
		if not nodeInfo or not nodeInfo.entryIDs or 2 ~= #nodeInfo.entryIDs then return end

		--local currentEntryID = nodeInfo.entryIDsWithCommittedRanks[1] or nil
		--local currentSelection
		--for index, entryID in ipairs(nodeInfo.entryIDs) do
			--if entryID == currentEntryID then currentSelection = index end
		--end

		local success = C_Traits.PurchaseRank(configID, KPNodeID)--C_Traits.SetSelection(configID, nodeID, nodeInfo.entryIDs[currentSelection == 2 and 1 or 2]) -- defaults to setting the second option, if not currently set
		if not success then 
			print("Knowledge Points not distributed")
			return 
		end
		commitSuccess = C_Traits.CommitConfig(configID)
	--end
end
local function GetProof(SkillLine)
    list = {}
	configID = C_ProfSpecs.GetConfigIDForSkillLine(SkillLine)
    configInfo = C_Traits.GetConfigInfo(configID)
	
    if configInfo == nil then
		return 
	end
    for _, treeID in ipairs(configInfo.treeIDs) do 
        Treenodes = C_Traits.GetTreeNodes(treeID)
		tabInfo = C_ProfSpecs.GetTabInfo(treeID)
        for i, nodeID in ipairs(Treenodes) do
			knowledgelearned = 0
			knowledgeMax = 0
			profnodename = "empty"
            nodeInfo = C_Traits.GetNodeInfo(configID, nodeID)
			if not nodeInfo then return end
			  if nodeInfo.ranksPurchased > 1 then
				knowledgelearned = knowledgelearned + (nodeInfo.currentRank - 1)
				knowledgeMax = knowledgeMax + (nodeInfo.maxRanks - 1)				
			  end
            for _, entryID in ipairs(nodeInfo.entryIDs) do -- each node can have multiple entries (e.g. choice nodes have 2)
                entryInfo = C_Traits.GetEntryInfo(configID, entryID)
                if entryInfo and entryInfo.definitionID then
                    definitionInfo = C_Traits.GetDefinitionInfo(entryInfo.definitionID)
					if definitionInfo.overrideName then 
						profnodename = definitionInfo.overrideName
					end
                end
            end
			if profnodename ~= "empty" then
			    table.insert(list,{knowledgelearned, knowledgeMax, nodeID, profnodename})
            end
        end
    end
    return list
end
local function PrepareProfBuildStep(Prof,SkillLine)
	local success, result = pcall(function()
		if UnitIsDeadOrGhost("player") or State == "PAUSE" then
			return 
		end
		Ownbuild = nil
		if Prof == "TWWH" then
			Ownbuild = OwnTWWHProfBuild
			ProfBuildSteps = DefTWWHProfTreeSteps
		elseif Prof == "TWWM" then
			Ownbuild = OwnTWWMProfBuild
			ProfBuildSteps = DefTWWMProfTreeSteps
		elseif Prof == "DFH" then
			Ownbuild = OwnDFHProfBuild
			ProfBuildSteps = DefDFHProfTreeSteps
		elseif Prof == "TWWM" then
			Ownbuild = OwnDFMProfBuild
			ProfBuildSteps = DefDFMProfTreeSteps			
		end
		if Ownbuild == true then
			SavedOwnProfBuild = ReadFile('/scripts/AKH/'..Prof..'ProfTreeBuild.json')
			if not SavedOwnProfBuild then
				print("Own build not found.")
			else 
				OwnProfTreeSteps = {}
				local File = ReadFile('/scripts/AKH/'..Prof..'ProfTreeBuild.json')
				OwnProfTreeSteps = JsonDecode(File)
				if #OwnProfTreeSteps < 1 then
					print("Own build is empty")
					return
				else
					ProfBuildSteps = OwnProfTreeSteps
				end				
			end
		end	
		ActProofList = GetProof(SkillLine)
		--DevTools_Dump(ActProofList)
		CompareList = {}
		for i = 1, #ProfBuildSteps do
			for v, k in pairs(KPNodeIDs) do
				if ProfBuildSteps[i] == k.kname and SkillLine == k.SkLine then
					if #CompareList < 1 then						
						table.insert(CompareList,{5, k.knid})		
					else 
						addedpoints = nil
						for vc, kc in pairs(CompareList) do
							if kc[2] == k.knid then
								kc[1] = kc[1] + 5 
								addedpoints = true
							end
						end
						if not addedpoints then
							table.insert(CompareList,{5, k.knid})
						end
					end
					for vca, kca in pairs(CompareList) do
						findid = kca[2]
						for va, ka in pairs(ActProofList) do
							if ka[3] == findid then
								if ka[1] < kca[1] then
									if not UnitCastingInfo("player") then
										PurchaseRank4KP(SkillLine,ka[3])
										print("Added Knowledge Point in "..ka[4].."")
									end
									return
								end
							end
						end
					end
				end
			end	
		end
	end)
	if success then
	  
	else
	   print("PrPrBuSt"..result)
	end
end
--Knowledge Point Check
local function ProfTreeCheck()
	local success, result = pcall(function()
		if UnitIsDeadOrGhost("player") or State == "PAUSE" then
			return 
		end 
		KPUnspent = nil		
		if LoadExpansion == "The War Within" then
			if AutoUseTWWHProfBuild == true then
				KPUnspent = C_ProfSpecs.GetCurrencyInfoForSkillLine(2877)
				if KPUnspent.numAvailable > 0 then
					--print("Unspent Knowledge Points for TWW Herbalism available.")
					PrepareProfBuildStep("TWWH",2877)
					return
				end
			end
			if AutoUseTWWMProfBuild == true then
				KPUnspent = C_ProfSpecs.GetCurrencyInfoForSkillLine(2881)
				if KPUnspent.numAvailable > 0 then
					--print("Unspent Knowledge Points for TWW Mining available.")
					PrepareProfBuildStep("TWWM",2881)
					return
				end
			end
		elseif LoadExpansion == "Dragonflight" then
			if AutoUseDFHProfBuild == true then
				KPUnspent = C_ProfSpecs.GetCurrencyInfoForSkillLine(2832)
				if KPUnspent.numAvailable > 0 then
					--print("Unspent Knowledge Points for DF Herbalism available.")
					PrepareProfBuildStep("DFH",2832)
					return
				end
			end
			if AutoUseDFMProfBuild == true then
				KPUnspent = C_ProfSpecs.GetCurrencyInfoForSkillLine(2833)
				if KPUnspent.numAvailable > 0 then
					--print("Unspent Knowledge Points for DF Mining available.")
					PrepareProfBuildStep("DFM",2833)
					return
				end
			end
		end	
	end)
	if success then
	  
	else
	   print("PrTrCh"..result)
	end
	C_Timer.After(10, ProfTreeCheck)
end
ProfTreeCheck()
-- Unstuck and Visualizing
Draw:Sync(function(draw) 
	px, py, pz = ObjectPosition("player")
	draw:SetWidth(2)
    draw:SetAlpha(100)
    local timeElapsed = (GetTime() - LastTime)
    if State == "MOVE"
	or State == "IDLE"
	or State == "FLEE" then
		if timeElapsed > 0.1 and IsIndoors("player") and RescLogging then
			--RescLogging = false
			--State = "RESCUE"
			--if tarobject then
				--BLPCheck(x,y,z)
				--tarobject = nil
				--x,y,z = nil,nil,nil
			--end
			--if Human then
				--FaceDirection((ObjectRotation('player') + math.rad(180)),true)
			--else
				--FaceDirection(((ObjectRotation('player') + math.rad(180))% (2*math.pi)),false)	
				--SendMovementHeartbeat() 
			--end
			--Rescuewalk()
			--[[FaceDirection((ObjectRotation('player') + math.rad(180)),true)
			Bunker = true
			C_Timer.After(1, function() 
				Bunker = false
			end)]]--
		end
	end 
	if x and x ~= 0 and timeElapsed > 0.05 then 
		draw:SetColor(255, 0, 0)          
        draw:Line(x, y, z, px, py, pz) 
	end
    if timeElapsed > 0.05 and ShowRPoints == true then        
        draw:SetColor(255, 0, 255)
        for vrp,krp in pairs(Points) do
            draw:Circle(krp[1],krp[2],krp[3], 0.1) 
			Draw:Text("P. "..vrp, "GameFontNormalSmall", krp[1],krp[2],krp[3])
        end
    end
	if timeElapsed > 0.05 and ShowWPoints == true then     
        draw:SetColor(255,255,255)   
        for vwp,kwp in pairs(WhitelistedPlace) do
            draw:Circle(kwp[1],kwp[2],kwp[3],kwp[4])     
			Draw:Text("P. "..vwp, "GameFontNormalSmall", kwp[1],kwp[2],kwp[3])
        end
    end
	if timeElapsed > 0.05 and ShowBPoints == true then     
        draw:SetColor(0,0,0)  
        for vbp,kbp in pairs(BlacklistedPlace) do
            draw:Circle(kbp[1],kbp[2],kbp[3],kbp[4])  
			Draw:Text("P. "..vbp, "GameFontNormalSmall", kbp[1],kbp[2],kbp[3])
        end
    end
    crash = false
    if timeElapsed > 0.05 and not UnitOnTaxi("player") and State ~= "PAUSE" and State ~= "INN" then
		LastTime = GetTime() 
        local theta = ObjectRotation('player')
		if not theta then
			return
		end
        for v, k in pairs(AngleStepsFly) do
            crash = false
            thet = theta+k 
            local l = ObjectRotation('player') + math.rad(90) 
			local r = ObjectRotation('player') - math.rad(90) 
			--print(l,r)
            local sinus30 = math.rad(25) 
            local sinus60 = math.rad(65) 
            local traceDist = height-0.3 / sinus60 * sinus30
			
            for i = 0.03, 0.65, 0.03 do
                local XXl, YYl, ZZl = RotateVector(px, py, pz+0.5, l, i)
                local XXr, YYr, ZZr = RotateVector(px, py, pz+0.5, r, i)   
                local XXrv, YYrv, ZZrv = RotateVector(XXr, YYr, (ZZr + (height-0.3)), thet, traceDist)
                local XXlv, YYlv, ZZlv = RotateVector(XXrv, YYrv, ZZrv, l, i+i)
                local x0, y0, z0 = TraceLine(XXrv, YYrv, ZZrv, XXlv, YYlv, ZZlv , hitFlags)
                local x1, y1, z1 = TraceLine(XXl, YYl, ZZl, XXlv, YYlv, ZZlv , hitFlags)
                local x2, y2, z2 = TraceLine(XXr, YYr, ZZr, XXrv, YYrv, ZZrv  , hitFlags)
				--draw:Line(XXrv, YYrv, ZZrv, XXlv, YYlv, ZZlv)
                --draw:Line(XXl, YYl, ZZl, XXlv, YYlv, ZZlv)
                --draw:Line(XXr, YYr, ZZr, XXrv, YYrv, ZZrv)
                if tonumber(x0) ~= 0 
                or tonumber(x1) ~= 0
                or tonumber(x2) ~= 0 then
					crash = true                      
                end    
            end
            if crash == false then 
                if (thet-theta) < (-0.01) or (thet-theta) > (0.01) then
                    --print("AVOID")
					if Human then
						FaceDirection(thet, true)				
					else
						FaceDirection((thet % (2*math.pi)), false)
						SendMovementHeartbeat() 
					end
				end               
                return
            end    
        end  
    end         
end)
Draw:Enable()

-- MOVE CHECK
local function XMoveCheck()
	local success, result = pcall(function()
		if UnitIsDeadOrGhost("player") or State == "PAUSE" then
			return 
		end 
		if State == "GOtoMAIL" and nmx then 
			if x ~= nmx then
				x,y,z = nmx,nmy,nmz
			else
				for v,k in pairs(MailboxStore) do
					local Map = select(8, GetInstanceInfo())	
					local mmap,xp,yp,zp = tonumber(k[1]),tonumber(k[2]),tonumber(k[3]),tonumber(k[4])		
					if (nmx+nmy+nmz) == (xp+yp+zp) then
						return
					end
				end
				x,y,z = nil, nil, nil
				nmx,nmy,nmz = nil,nil,nil
				State = "IDLE"
			end
		end
		if State == "MOVE" then
			if not countmovelose then
				countmovelose = 0
			end
			if countmovelose > 0 then
				--print("Zero moves: "..countmovelose)
			end
			if not x or x == 0 then
				tarobject = nil
				fishpool = nil
				fishpoolobj = nil
				NextPoint()
				return
			end
			ActKoorCheck = x+y+z
			--print(ActKoorCheck)
			for v,k in pairs(Points) do
				xp,yp,zp,rp = k[1],k[2],k[3],k[4]
				local ListKoorCheck = xp+yp+zp
				if (ActKoorCheck - ListKoorCheck) < 2 and (ActKoorCheck - ListKoorCheck) > -2 then
					return
				end
			end
			print("wrong koordinates")
			countmovelose = countmovelose + 1
			tarobject = nil
			fishpool = nil
			fishpoolobj = nil
			NextPoint()
		end
	end)
	if success then
	  
	else
	   print("XMove"..result)
	end
	C_Timer.After(3, XMoveCheck)
end
XMoveCheck()

-- Flee Jump
local function FleeJump()
	local success, result = pcall(function()
		randomflee = 5
		if UnitIsDeadOrGhost("player") then
			return 
		end 
		randomflee = math.random(2,5)
		if State == "FLEE" then
			JumpOrAscendStart()
			C_Timer.After(0.02, function() Eval('AscendStop()','') end)
		end
	end)
	if success then
	  
	else
	   print("Flee"..result)
	end
	C_Timer.After(randomflee, FleeJump)
end
FleeJump()

-- fight
local function fight()
	local success, result = pcall(function()
		if not FightMobs then
			return
		end
		if UnitIsDeadOrGhost("player") then 
			return 
		end 
		if State == "PAUSE" 
		or State == "HEARTSTONE"
		or State == "GUILDBANK"
		or State == "REPAIR/SELL"
		or State == "SPORE"
		or State == "METAMORPH/EZ-MINE"
		or State == "DEAD"
		or State == "GOtoMAIL"
		or State == "SENDMAIL"
		or State == "FLEE" then
			return
		end	
		if UnitAffectingCombat("player") and State == "FIGHT" then
			if moving then
				Eval('ToggleAutoRun()','')
				moving = nil
			end
			--local foo = PlayerTarget()
			local xta,yta,zta = ObjectPosition('target')
			local Fightdistance = FastDistance(px, py, pz, xta,yta,zta)
			if xta then
				local angle, calced_pitch = CalculateAngleAndPitchToPoint({x=px,y=py,z=pz},{x=xta,y=yta,z=zta}) 
				FaceDirection(angle, true)
			end
			if xta and Fightdistance > 4 then
				x,y,z = NodeLandPlace(xta,yta,zta) 
				MoveTo(x,y,z)				
			end
		end
	end)
	if success then
	  
	else
	   print("Fig"..result)
	end
	C_Timer.After(1, fight)
end
fight()
-- Agro Check
local function AgroCheck()
	local success, result = pcall(function()
		if UnitIsDeadOrGhost("player") then
			return 
		end 
		if State == "PAUSE" 
		or State == "HEARTSTONE"
		or State == "GUILDBANK"
		or State == "REPAIR/SELL"
		or State == "SPORE"
		or State == "METAMORPH/EZ-MINE"
		or State == "DEAD" then
			return
		end 
		local isGliding, canGlide, forwardSpeed = C_PlayerInfo.GetGlidingInfo()
		local active = GetShapeshiftFormID()
		if UnitAffectingCombat("player") and not canGlide and not (IsMounted() or active == 27) and State ~= "FLEE" then
			if not FightMobs then
				State = "FLEE"
				Unstuck = true
				Eval('MoveForwardStart()',"")
				Flee = true
			else 
				State = "FIGHT"
			end
		end 
		if not UnitAffectingCombat("player") and (State == "FLEE" or State == "FIGHT") then 
			if IsPlayerMoving() then        
				Eval('MoveForwardStop()', "")
			end
			Unstuck = false
			Flee = false
			State = "IDLE"
		end
	end)
	if success then
	  
	else
	   print("AgCh"..result)
	end
	C_Timer.After(2, AgroCheck)
end
AgroCheck()


-- Lastloot check
local function LastlootCheck()
	local success, result = pcall(function()
		if UnitIsDeadOrGhost("player") then 
			return 
		end 
		if State == "PAUSE"
		or State == "FIGHT"
		or State == "INN"
		or State == "ITEMUSE"
		or State == "HEARTSTONE"
		or State == "GUILDBANK"
		or State == "REPAIR/SELL"
		or State == "SENDMAIL"
		or State == "GOtoMAIL"
		or State == "METAMORPH/EZ-MINE"
		or State == "CHARGEVIGOR"
		or State == "SPORE"
		or State == "CUSTOM_MOVE"
		or State == "OVERLOAD"
		or State == "OVERLOAD_ORB" 
		or State == "DEAD" then
			return
		end	
		if (HS or UIReload) and Lastloot and not UnitCastingInfo("player") then
			if UIReload and ((Lastloot + (ReloadTimer*60)) < GetTime()) then
				Eval('ReloadUI()','')
			end
			if HS and ((Lastloot + (HSafterTime*60)) < GetTime()) then
				if Flee == true then
					Eval('MoveForwardStop()','')
				end
				if moving then
					Eval('ToggleAutoRun()','')
					moving = nil
				end
				if IsFlying() and not IsPlayerMoving() then	
					local active = GetShapeshiftFormID()
					if Class == "DRUID" and active then
						NoShapeshift()
					else
						Dismount()
					end
				elseif not IsFlying() and not IsPlayerMoving() then
					local active = GetShapeshiftFormID()
					if Class ~= "DRUID"
					or not active then	
						local numBags = 5
						for i = 0, numBags do
							local numBagSlots = C_Container.GetContainerNumSlots(i)
							for j = 0, numBagSlots do
								local itemID = C_Container.GetContainerItemID(i, j)				
								if itemID == 6948 then
									ItemName = select(1, C_Item.GetItemInfo(itemID))
									print("Use Heartstone")	
									State = "HEARTSTONE"
									UseItemByName(ItemName)					
								end
							end	
						end
					else
						NoShapeshift()
					end
				end
			end
		end
		if State == "GUILDBANK" 
		or State == "REPAIR/SELL" then
			if Lastloot and (Lastloot + 120) < GetTime() then
				State = "IDLE"
			end
		end
	end)
	if success then
	  
	else
	   print("LaLoCh"..result)
	end
	C_Timer.After(3, LastlootCheck)
end
LastlootCheck()
-- freeze check
local function FreezeCheck()
	local success, result = pcall(function()
		if not IsInGame() or UnitIsDeadOrGhost("player") then 
			return
		end 
		if State == "PAUSE" 
		or State == "FISHING"
		or State == "SPOTFISHING"
		or State == "FIGHT"
		or State == "HEARTSTONE"
		or State == "GUILDBANK"
		or State == "REPAIR/SELL"
		or State == "DEAD" 
		or State == "AWOID"
		or State == "INN"
		or State == "SPORE"
		or State == "METAMORPH/EZ-MINE"
		or State == "SENDMAIL"
		or State == "CHARGEVIGOR"
		or State == "CUSTOM_MOVE"
		or State == "OVERLOAD"
		or State == "OVERLOAD_ORB" 
		or warchest then
			timeToCheck = nil
			return
		end	
		DeadmanTimer = nil
		if not timeToCheck and ((Vigor >= WVigor) or (SteadyFly == true) or (IsIndoors("player") == true)) then
			timeToCheck = GetTime()+6
			LastX, LastY, LastZ = px, py, pz
		end
		if timeToCheck and timeToCheck < GetTime() and ((Vigor >= WVigor) or (SteadyFly == true) or (IsIndoors("player") == true)) then
			DistanceCheck = FastDistance(LastX, LastY, LastZ, px, py, pz)
			if DistanceCheck < 5 then
				freeze = freeze + 1
				awoid()
			end
			if DistanceCheck > 5 then		
				timeToCheck = nil
			end
		end
	end)
	if success then
	  
	else
	   print("FrzCh"..result)
	end
	C_Timer.After(2, FreezeCheck)
end
FreezeCheck()

-- Dead or Ghost Check
local function DeadManCheck()
	local success, result = pcall(function()
		if State == "PAUSE" then
			return
		end
		if UnitIsDeadOrGhost("player") and State ~= "DEAD" then
			x, y, z = nil, nil, nil
			CanDuplicateHerb = false
			State = "DEAD"
			if not DeadmanTimer then
				DeadmanTimer = GetTime()+35
			end
			for k in pairs (RescuePoints) do
				RescuePoints[k] = nil
			end
			Eval('MoveForwardStop()',"")
			C_Timer.After(1.5, function() 
				if UnitIsDead("player") then
					RepopMe() 
				end
			end)				
		elseif not UnitIsDeadOrGhost("player") and State == "DEAD" then       
			State = "IDLE" 
			DeadmanTimer = nil
		end
	end)
	if success then
	  
	else
	   print("DeCh"..result)
	end
	C_Timer.After(3, DeadManCheck)
end
DeadManCheck()
-- Deadmove Check
local function DeadMoveCheck()
	local success, result = pcall(function()
		if State == "PAUSE" then
			return
		end    
		if State == "DEAD" then	
			if Flee == true then
				Eval('MoveForwardStop()','')
			end
			local x, y, z = ObjectPosition("player")
			C_Timer.After(0.05, function() 
				local px, py, pz = ObjectPosition("player") 
				if tonumber(pz) > (z+5) then 
					JumpOrAscendStart()
					C_Timer.After(0.02, function() Eval('AscendStop()','') end)
					print("Interrupt DeadMove")
				end	   
			end)
		end
	end)
	if success then
	  
	else
	   print("DeMoCh"..result)
	end
	C_Timer.After(0.1, DeadMoveCheck)
end
DeadMoveCheck()
-- Resurrect
local function ResatSpirHeal()	
	local success, result = pcall(function()
		if State == "PAUSE" then
			return
		end    
		if State == "DEAD" then	
			Resstarobject = nil
			Unstuck = false	
			local objects = Objects(5)    
			local SpirHealers = {6491, 29259, 72676, 39660, 88148, 3778, 126141, 92355, 112180, 173514, 4318, 2282, 3777, 2281, 2290, 2289, 2291, 4322, 4039, 2298, 3146, 2294, 4340, 2292, 32537, 65183, 94070, 104689, 115774, 133783, 144412, 158175, 163310, 163311, 209505, 18153, 13056, 203706}
			for v,k in pairs(objects) do
				Spiritfound = false
				for vsp,ksp in pairs(SpirHealers) do
					if ObjectId(k) == ksp then
						Spiritfound = true
					end
				end
				if Spiritfound == true and (ObjectDistance('player', k)< 30) then
					local x, y, z = ObjectPosition(k)
					Resstarobject = k
					local Interactdistance = ObjectDistance('player', k)
					local AngelDist2D = FastDistance2D(x,y,px,py)
					if AngelDist2D <= 4 then
						MoveTo(x, y, z)
					end
					if 	Interactdistance <= 4 then
						ObjectInteract(k)
						C_Timer.After(0.3, function() 
							C_PlayerInteractionManager.ConfirmationInteraction(Enum.PlayerInteractionType.SpiritHealer) 
						end)
						C_Timer.After(0.5, function() 
							StaticPopup_HideExclusive() 
						end)
						C_Timer.After(0.7, function() 
							if not UnitIsDeadOrGhost("player") then	
								Unstuck = false
								DeadmanTimer = nil
								Resurrections = Resurrections + 1
								Lootdistance = nil
								tarobject = nil
								x,y,z = nil, nil ,nil
								if State ~= "PAUSE" then
									State = "IDLE"
								end	
								if not IsOutdoors("player") then
									HSwalk()
								end
							end
						end)
					elseif 	Interactdistance > 4 and Interactdistance < 20 then
						C_Timer.After(0.1, function() MoveTo(px, py, (pz+4)) end)    
						C_Timer.After(0.5, function() MoveTo(x, y, (z+1)) end)     
					elseif 	Interactdistance >= 20 and Interactdistance < 100 then
						C_Timer.After(0.01, function() 
							local px1, py1, pz1 = ObjectPosition("player")
							if pz1 > (pz+1) then 
								JumpOrAscendStart()
								C_Timer.After(0.005, function() Eval('AscendStop()','') end)
								MoveTo(px, py, (pz+4)) 
							else  
								MoveTo(x, y, (z+1))
							end                    
						end)
					elseif Interactdistance >= 100 then
						Eval('PortGraveyard()','')
					end
					return
				end
			end	
			if not Resstarobject then
			print("Spirit Healer not found. Port to Graveyard")
				Eval('PortGraveyard()','')
			end
		end
	end)
	if success then
	  
	else
	   print("ReSpHe"..result)
	end
	C_Timer.After(1, ResatSpirHeal)
end
ResatSpirHeal()


local function DrawGeneralOtions()
	Generalframe = AceGUI:Create("Frame")
	Generalframe:SetTitle("General Options")
	Generalframe:SetWidth(600)
	Generalframe:SetHeight(630)
	Generalframe:SetPoint("TOPLEFT",350,0)
	Generalframe:SetStatusText("Tinkr version:"..vers)
	Generalframe:SetCallback("OnClose", function(widget) AceGUI:Release(widget)
		Generalframe = nil
	end)
	Generalframe:SetLayout("Flow")
	
	local checkbox = AceGUI:Create("CheckBox")
	checkbox:SetValue(SteadyFly)
	checkbox:SetType("checkbox")
	checkbox:SetLabel("Use Steady Fly")
	checkbox:SetRelativeWidth(0.23)
	checkbox:SetCallback("OnValueChanged",function() 
		if (checkbox:GetValue()) then
			if C_UnitAuras.GetPlayerAuraBySpellID(404468) then
				SteadyFly = true
				print("Use Steady Fly")
			else
				print("Please activate Steady Fly first")
				checkbox:SetValue(false)
			end
		else
			SteadyFly = false
			print("Use Dragonriding")
		end
		SaveSettings()
	end)
	Generalframe:AddChild(checkbox)
	
	local checkbox = AceGUI:Create("CheckBox")
	checkbox:SetValue(Human)
	checkbox:SetType("checkbox")
	checkbox:SetLabel("Flying like Human")
	checkbox:SetRelativeWidth(0.25)
	checkbox:SetCallback("OnValueChanged",function()		
		if (checkbox:GetValue()) then
			Human = true
			print("Flying like human enable")
		else
			Human = false
			print("Flying like human disable") 
		end
		SaveSettings()
	end)
	Generalframe:AddChild(checkbox)
	
	local button = AceGUI:Create("Button")
	button:SetText("Scripts")
	button:SetRelativeWidth(0.22)
	button:SetHeight(30)
	button:SetCallback("OnClick", function() 
		if not Scriptsframe then
			AceGUI:Release(Generalframe) 
			Generalframe = nil
			DrawScriptsOtions()
		end
	end)
	Generalframe:AddChild(button)
	
	local button = AceGUI:Create("Button")
	button:SetText("Flasks / Buffs")
	button:SetRelativeWidth(0.22)
	button:SetHeight(30)
	button:SetCallback("OnClick", function() 
		if not Flaskframe then
			AceGUI:Release(Generalframe) 
			Generalframe = nil
			DrawFlaskOtions()
		end
	end)
	Generalframe:AddChild(button)

	local checkbox = AceGUI:Create("CheckBox")
	checkbox:SetValue(Druid)
	checkbox:SetType("checkbox")
	checkbox:SetLabel("Use druid 'Flight Form'")
	checkbox:SetRelativeWidth(0.31)
	checkbox:SetCallback("OnValueChanged",function() 
		if (checkbox:GetValue()) then
			Druid = true
			FlyForm = "Druid"
			print("Use Druide Flight Form") 
		else
			Druid = false
			FlyForm = "Random"
			print("Use random favorite mount") 
		end
		SaveSettings()
	end)
	Generalframe:AddChild(checkbox)
	
	local checkbox = AceGUI:Create("CheckBox")
	checkbox:SetValue(IgnoreGHigh)
	checkbox:SetType("checkbox")
	checkbox:SetLabel("Ignore height difference.")
	checkbox:SetRelativeWidth(0.33)
	checkbox:SetCallback("OnValueChanged",function() 
		if (checkbox:GetValue()) then
			IgnoreGHigh = true
			print("Nodes that are too high or too deep will be not ignored.") 
		else
			IgnoreGHigh = false
			print("Nodes that are too high or too deep will be ignored.") 
		end
		SaveSettings()
	end)
	Generalframe:AddChild(checkbox)
	
	local dropdown = AceGUI:Create("Dropdown")
	dropdown:SetLabel("Flyspeed:")
	dropdown:SetRelativeWidth(0.14)
	dropdown:SetHeight(15)
	dropdown:SetList{"15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32",
					"33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50"}
    dropdown:SetValue(MarshSpeed)
	dropdown:SetCallback("OnValueChanged",function() 
		MarshSpeed = tonumber(dropdown:GetValue()) 
		SaveSettings()
	end)
	Generalframe:AddChild(dropdown)
	
	local dropdown = AceGUI:Create("Dropdown")
	dropdown:SetLabel("Min. Vigor:")
	dropdown:SetRelativeWidth(0.14)
	dropdown:SetHeight(15)
	dropdown:SetList{"1", "2", "3", "4", "5", "6"}
    dropdown:SetValue(WVigor)
	dropdown:SetCallback("OnValueChanged",function() 
		WVigor = tonumber(dropdown:GetValue()) 
		SaveSettings()
	end)
	Generalframe:AddChild(dropdown)
	
	local checkbox = AceGUI:Create("CheckBox")
	checkbox:SetValue(NoPrio)
	checkbox:SetType("checkbox")
	checkbox:SetLabel("Ignore global Priority next to the player.")
	checkbox:SetRelativeWidth(0.5)
	checkbox:SetCallback("OnValueChanged",function()		
		if (checkbox:GetValue()) then
			NoPrio = true
			print("Global Priority is disable next to the player")
		else
			NoPrio = false
			print("Global Priority is enable next to the player") 
		end
		SaveSettings()
	end)
	Generalframe:AddChild(checkbox)
	
	local editbox = AceGUI:Create("EditBox")
	editbox:SetLabel("Range without prio")
	editbox:SetText(NoPrioRange)
	editbox:SetRelativeWidth(0.22)
	editbox:SetHeight(40)
	editbox:SetCallback("OnEnterPressed", function(widget, event, text) 
		if text == nil then
			NoPrioRange = 20
		else
			NoPrioRange = tonumber(text)
		end
		SaveSettings()
	end)
	Generalframe:AddChild(editbox)
	
	local heading = AceGUI:Create("Heading")
	heading:SetText("Mail:")
	heading:SetRelativeWidth(1)
	Generalframe:AddChild(heading)
	
	local checkbox = AceGUI:Create("CheckBox")
	checkbox:SetValue(Mail)
	checkbox:SetType("checkbox")
	checkbox:SetLabel("Mail")
	checkbox:SetRelativeWidth(0.2)
	checkbox:SetCallback("OnValueChanged",function()		
		if (checkbox:GetValue()) then
			Mail = true
			print("Send Mail enable")
		else
			Mail = false
			print("Send Mail disable") 
		end
		SaveSettings()
	end)
	Generalframe:AddChild(checkbox)
	
	local editbox = AceGUI:Create("EditBox")
	editbox:SetLabel("Send to:")
	editbox:SetText(MailChar)
	editbox:SetRelativeWidth(0.4)
	editbox:SetHeight(40)
	editbox:SetCallback("OnEnterPressed", function(widget, event, text) 
		MailChar = text  
		SaveSettings()
	end)
	Generalframe:AddChild(editbox)
	
	local editbox = AceGUI:Create("EditBox")
	editbox:SetLabel("Mailing time interval in minutes")
	editbox:SetText(MailTime)
	editbox:SetRelativeWidth(0.33)
	editbox:SetHeight(40)
	editbox:SetCallback("OnEnterPressed", function(widget, event, text) 
		if text == nil then
			text = 120
		end
		MailTime = tonumber(text)  
		TimeToSendMail = MailTime * 60 + time()
		SaveSettings()
	end)
	Generalframe:AddChild(editbox)
	
	local heading = AceGUI:Create("Heading")
	heading:SetText("Use heartstone or reload UI if no loot:")
	heading:SetRelativeWidth(1)
	Generalframe:AddChild(heading)

	local checkbox = AceGUI:Create("CheckBox")
	checkbox:SetValue(HS)
	checkbox:SetType("checkbox")
	checkbox:SetLabel("Heartstone")
	checkbox:SetRelativeWidth(0.17)
	checkbox:SetCallback("OnValueChanged",function()		
		if (checkbox:GetValue()) then
			HS = true
			print("Use Heartstone enable")
		else
			HS = false
			print("Use Heartstone disable") 
		end
		SaveSettings()
	end)
	Generalframe:AddChild(checkbox)
	
	local editbox = AceGUI:Create("EditBox")
	editbox:SetLabel("Use HS if no loot after: Minuts")
	editbox:SetText(HSafterTime)
	editbox:SetRelativeWidth(0.30)
	editbox:SetHeight(40)
	editbox:SetCallback("OnEnterPressed", function(widget, event, text) 
		if text == nil then
			HSafterTime = 10
		else
			HSafterTime = tonumber(text)
		end
		SaveSettings()
	end)
	Generalframe:AddChild(editbox)
	
	local checkbox = AceGUI:Create("CheckBox")
	checkbox:SetValue(UIReload)
	checkbox:SetType("checkbox")
	checkbox:SetLabel("Reload UI")
	checkbox:SetRelativeWidth(0.16)
	checkbox:SetCallback("OnValueChanged",function()		
		if (checkbox:GetValue()) then
			UIReload = true
			print("Reload User Interface enable")
		else
			UIReload = false
			print("Reload User Interface disable") 
		end
		SaveSettings()
	end)
	Generalframe:AddChild(checkbox)
	
	local editbox = AceGUI:Create("EditBox")
	editbox:SetLabel("Reload UI if no loot after: Minuts")
	editbox:SetText(ReloadTimer)
	editbox:SetRelativeWidth(0.32)
	editbox:SetHeight(40)
	editbox:SetCallback("OnEnterPressed", function(widget, event, text) 
		if text == nil then
			ReloadTimer = 1
		else
			ReloadTimer = tonumber(text)
		end
		SaveSettings()
	end)
	Generalframe:AddChild(editbox)
	
	local heading = AceGUI:Create("Heading")
	heading:SetText("Fight:")
	heading:SetRelativeWidth(1)
	Generalframe:AddChild(heading) 

	local checkbox = AceGUI:Create("CheckBox")
	checkbox:SetValue(FightMobs)
	checkbox:SetType("checkbox")
	checkbox:SetLabel("Use external Rotation to fight Mobs back")
	checkbox:SetRelativeWidth(0.8)
	checkbox:SetCallback("OnValueChanged",function()		
		if (checkbox:GetValue()) then
			FightMobs = true
			print("Using external Combat Rotation enable")
		else
			FightMobs = false
			print("Using external Combat Rotation disable") 
		end
		SaveSettings()
	end)
	Generalframe:AddChild(checkbox)

	local heading = AceGUI:Create("Heading")
	heading:SetText("Guild bank:")
	heading:SetRelativeWidth(1)
	Generalframe:AddChild(heading)

	local checkbox = AceGUI:Create("CheckBox")
	checkbox:SetValue(GuildBank)
	checkbox:SetType("checkbox")
	checkbox:SetLabel("Mobiles guild bank")
	checkbox:SetRelativeWidth(0.5)
	checkbox:SetCallback("OnValueChanged",function() 
		if (checkbox:GetValue()) then
			GuildBank = true
			print("Use guild bank to store farmed goods ") 
		else
			GuildBank = false
			print("guild bank disable") 
		end
		SaveSettings()
	end)
	Generalframe:AddChild(checkbox)
	
	local editbox = AceGUI:Create("EditBox")
	editbox:SetLabel("Use guild bank every: Hours")
	editbox:SetText(GBafterTime)
	editbox:SetRelativeWidth(0.45)
	editbox:SetHeight(40)
	editbox:SetCallback("OnEnterPressed", function(widget, event, text) 
		if text == nil then
			text = 3
		end
		GBafterTime = tonumber(text)  
		TimeToUseGB = GBafterTime * 3600 + time()
		SaveSettings()
	end)
	Generalframe:AddChild(editbox)
	
	local heading = AceGUI:Create("Heading")
	heading:SetText("Tundra Mammoth:")
	heading:SetRelativeWidth(1)
	Generalframe:AddChild(heading)

	local checkbox = AceGUI:Create("CheckBox")
	checkbox:SetValue(Mammut)
	checkbox:SetType("checkbox")
	checkbox:SetLabel("Use for repairing.")
	checkbox:SetRelativeWidth(0.24)
	checkbox:SetCallback("OnValueChanged",function()
		if (checkbox:GetValue()) then
			Mammut = true
			print("Use Tundra Mammoth for repairing") 
		else
			Mammut = false
			print("Tundra Mammoth repairing is disable") 
		end
		SaveSettings()
	end)
	Generalframe:AddChild(checkbox)
	
	local checkbox = AceGUI:Create("CheckBox")
	checkbox:SetValue(GuildRepair)
	checkbox:SetType("checkbox")
	checkbox:SetLabel("Use guild gold.")
	checkbox:SetRelativeWidth(0.22)
	checkbox:SetCallback("OnValueChanged",function()
		if (checkbox:GetValue()) then
			GuildRepair = true
			print("Use guild gold to repair") 
		else
			GuildRepair = false
			print("Use own gold to repair") 
		end
		SaveSettings()
	end)
	Generalframe:AddChild(checkbox)
	
	local checkbox = AceGUI:Create("CheckBox")
	checkbox:SetValue(MammutSell)
	checkbox:SetType("checkbox")
	checkbox:SetLabel("Use for sell junk.")
	checkbox:SetRelativeWidth(0.24)
	checkbox:SetCallback("OnValueChanged",function()
		if (checkbox:GetValue()) then
			MammutSell = true
			print("Use Tundra Mammoth for sell junk") 
		else
			MammutSell = false
			print("Selling junk to Tundra Mammoth is disable") 
		end
		SaveSettings()
	end)
	Generalframe:AddChild(checkbox)
	
	local editbox = AceGUI:Create("EditBox")
	editbox:SetLabel("Empty slots before sell.")
	editbox:SetText(FreeSlots)
	editbox:SetRelativeWidth(0.25)
	editbox:SetHeight(40)
	editbox:SetCallback("OnEnterPressed", function(widget, event, text) 
		if text == nil then
			text = 5
		end
		FreeSlots = tonumber(text)  
		SaveSettings()
	end)
	Generalframe:AddChild(editbox)
	
	local heading = AceGUI:Create("Heading")
	heading:SetText("Visualization tools. Recommended for debugging only!")
	heading:SetRelativeWidth(1)
	Generalframe:AddChild(heading)
	
	local checkbox = AceGUI:Create("CheckBox")
	checkbox:SetValue(ShowRPoints)
	checkbox:SetType("checkbox")
	checkbox:SetLabel("Show route points")
	checkbox:SetRelativeWidth(0.25)
	checkbox:SetCallback("OnValueChanged",function()
		if (checkbox:GetValue()) then
			ShowRPoints = true
			print("Route points are visible. It can slow down WoW Client and cause FPS drops!") 
		else
			ShowRPoints = false
			print("Display of route points switched off.") 
		end
		SaveSettings()
	end)
	Generalframe:AddChild(checkbox)
	
	local checkbox = AceGUI:Create("CheckBox")
	checkbox:SetValue(ShowWPoints)
	checkbox:SetType("checkbox")
	checkbox:SetLabel("Show whitelisted locations")
	checkbox:SetRelativeWidth(0.34)
	checkbox:SetCallback("OnValueChanged",function()
		if (checkbox:GetValue()) then
			ShowWPoints = true
			print("Whitelisted locations are visible. It can slow down WoW Client and cause FPS drops!") 
		else
			ShowWPoints = false
			print("Display of whitelisted locations switched off.") 
		end
		SaveSettings()
	end)
	Generalframe:AddChild(checkbox)
	
	local checkbox = AceGUI:Create("CheckBox")
	checkbox:SetValue(ShowBPoints)
	checkbox:SetType("checkbox")
	checkbox:SetLabel("Show blacklisted locations")
	checkbox:SetRelativeWidth(0.34)
	checkbox:SetCallback("OnValueChanged",function()
		if (checkbox:GetValue()) then
			ShowBPoints = true
			print("Blacklisted locations are visible. It can slow down WoW Client and cause FPS drops!") 
		else
			ShowBPoints = false
			print("Display of blacklisted locations switched off.") 
		end
		SaveSettings()
	end)
	Generalframe:AddChild(checkbox)
end
local function DrawGatherOptions()
	Gatherframe = AceGUI:Create("Frame")
	Gatherframe:SetTitle("Treasure Options")
	Gatherframe:SetWidth(900)
	Gatherframe:SetHeight(180)
	Gatherframe:SetPoint("TOPLEFT",350,0)
	Gatherframe:SetStatusText("Tinkr version:"..vers)
	Gatherframe:SetCallback("OnClose", function(widget) AceGUI:Release(widget) SaveSettings() 
		Gatherframe = nil
	end)
	Gatherframe:SetLayout("Flow")
	
	local heading = AceGUI:Create("Heading")
	--heading:SetText("Other Ignoring")
	heading:SetRelativeWidth(1)
	Gatherframe:AddChild(heading)  	
	
	local checkbox = AceGUI:Create("CheckBox")
    checkbox:SetValue(OnlyTWWGather)
    checkbox:SetType("checkbox")
    checkbox:SetLabel("Ignore treasures")
    checkbox:SetRelativeWidth(0.17)
    checkbox:SetCallback("OnValueChanged",function() 
        if (checkbox:GetValue()) then
			OnlyTWWGather = true
		else
			OnlyTWWGather = false
		end
		SaveSettings()
		AceGUI:Release(Gatherframe) 
		DrawGatherOptions()
    end)
    Gatherframe:AddChild(checkbox)  
	
	local editbox = AceGUI:Create("EditBox")
	editbox:SetLabel("Ignore Range")
	editbox:SetText(TMobrange)
	editbox:SetRelativeWidth(0.11)
	editbox:SetHeight(40)
	editbox:SetCallback("OnEnterPressed", function(widget, event, text) 
		if text == nil then
			TMobrange = 30
		else
			TMobrange = tonumber(text)
		end
		SaveSettings()
	end)
	Gatherframe:AddChild(editbox)

	local checkbox = AceGUI:Create("CheckBox")
	checkbox:SetValue(TAvoidMobs)
	checkbox:SetType("checkbox")
	checkbox:SetLabel("Skip near aggro mobs")
	checkbox:SetRelativeWidth(0.20)
	checkbox:SetCallback("OnValueChanged",function()		
		if (checkbox:GetValue()) then
			TAvoidMobs = true
			print("Avoid treasure near aggro mobs enable")
		else
			TAvoidMobs = false
			print("Avoid treasure near aggro mobs disable") 
		end
		SaveSettings()
	end)
	Gatherframe:AddChild(checkbox)
	
	local checkbox = AceGUI:Create("CheckBox")
	checkbox:SetValue(TAvoidElite)
	checkbox:SetType("checkbox")
	checkbox:SetLabel("Skip near elite mobs")
	checkbox:SetRelativeWidth(0.20)
	checkbox:SetCallback("OnValueChanged",function()		
		if (checkbox:GetValue()) then
			TAvoidElite = true
			print("Avoid treasure near elite mobs enable")
		else
			TAvoidElite = false
			print("Avoid treasure near elite mobs disable") 
		end
		SaveSettings()
	end)
	Gatherframe:AddChild(checkbox)	
		
	
	
	local checkbox = AceGUI:Create("CheckBox")
    checkbox:SetValue(IgnWarChest)
    checkbox:SetType("checkbox")
    checkbox:SetLabel("Ignore War Supply Chest")
    checkbox:SetRelativeWidth(0.23)
    checkbox:SetCallback("OnValueChanged",function() 
        if (checkbox:GetValue()) then
			IgnWarChest = true
		else
			IgnWarChest = false
		end
		SaveSettings()
    end)
    Gatherframe:AddChild(checkbox) 
	

end

local function DrawHerbOptions()
	Herbframe = AceGUI:Create("Frame")
	Herbframe:SetTitle("Herbalism Options")
	Herbframe:SetWidth(900)
	Herbframe:SetHeight(650)
	Herbframe:SetPoint("TOPLEFT",350,0)
	Herbframe:SetStatusText("Tinkr version:"..vers)
	Herbframe:SetCallback("OnClose", function(widget) AceGUI:Release(widget) SaveSettings() 
		Herbframe = nil
	end)
	Herbframe:SetLayout("Flow")
	
	local heading = AceGUI:Create("Heading")
	--heading:SetText("Other Ignoring")
	heading:SetRelativeWidth(1)
	Herbframe:AddChild(heading)
	
	local checkbox = AceGUI:Create("CheckBox")
    checkbox:SetValue(IgnoreTWWh)
    checkbox:SetType("checkbox")
    checkbox:SetLabel("Ignore Herbalism")
    checkbox:SetRelativeWidth(0.17)
    checkbox:SetCallback("OnValueChanged",function() 
        if (checkbox:GetValue()) then
            IgnoreTWWh = true
        else
            IgnoreTWWh = false
        end
        for v, k in pairs(nodes) do
            if k.Art == "h" then  
                if (checkbox:GetValue()) then
                    k.Chk = true
                else
                    k.Chk = false
                end
            end
        end
		SaveSettings()
		AceGUI:Release(Herbframe) 
		DrawHerbOptions()
    end)
    Herbframe:AddChild(checkbox)
	
	local editbox = AceGUI:Create("EditBox")
	editbox:SetLabel("Ignore Range")
	editbox:SetText(HMobrange)
	editbox:SetRelativeWidth(0.11)
	editbox:SetHeight(40)
	editbox:SetCallback("OnEnterPressed", function(widget, event, text) 
		if text == nil then
			HMobrange = 30
		else
			HMobrange = tonumber(text)
		end
		SaveSettings()
	end)
	Herbframe:AddChild(editbox)

	local checkbox = AceGUI:Create("CheckBox")
	checkbox:SetValue(HAvoidMobs)
	checkbox:SetType("checkbox")
	checkbox:SetLabel("Skip near aggro mobs")
	checkbox:SetRelativeWidth(0.20)
	checkbox:SetCallback("OnValueChanged",function()		
		if (checkbox:GetValue()) then
			HAvoidMobs = true
			print("Avoid herb near aggro mobs enable")
		else
			HAvoidMobs = false
			print("Avoid herb near aggro mobs disable") 
		end
		SaveSettings()
	end)
	Herbframe:AddChild(checkbox)
	
	local checkbox = AceGUI:Create("CheckBox")
	checkbox:SetValue(HAvoidElite)
	checkbox:SetType("checkbox")
	checkbox:SetLabel("Skip near elite mobs")
	checkbox:SetRelativeWidth(0.20)
	checkbox:SetCallback("OnValueChanged",function()		
		if (checkbox:GetValue()) then
			HAvoidElite = true
			print("Avoid herb near elite mobs enable")
		else
			HAvoidElite = false
			print("Avoid herb near elite mobs disable") 
		end
		SaveSettings()
	end)
	Herbframe:AddChild(checkbox)	
	
	if LoadExpansion == "The War Within" or LoadExpansion == "Dragonflight" then
		local checkbox = AceGUI:Create("CheckBox")
		checkbox:SetValue(OverHerb)
		checkbox:SetType("checkbox")
		checkbox:SetLabel("Overload Herb")
		checkbox:SetRelativeWidth(0.15)
		checkbox:SetCallback("OnValueChanged",function()
			if (checkbox:GetValue()) then
				OverHerb = true
				print("Overload Herb enable") 
			else
				OverHerb = false
				print("Overload Herb disable") 
			end
			SaveSettings()
		end)
		Herbframe:AddChild(checkbox)	
		if LoadExpansion == "Dragonflight" then
			local checkbox = AceGUI:Create("CheckBox")
			checkbox:SetValue(Lambent)
			checkbox:SetType("checkbox")
			checkbox:SetLabel("Lambent")
			checkbox:SetRelativeWidth(0.10)
			checkbox:SetCallback("OnValueChanged",function()
				if (checkbox:GetValue()) then
					Lambent = true
					print("Overload Lambent Herb enable") 
				else
					Lambent = false
					print("Overload Lambent Herb disable") 
				end
				SaveSettings()
			end)
			Herbframe:AddChild(checkbox)
		end
		local button = AceGUI:Create("Button")
		button:SetText("Herbalism Specializations")
		button:SetRelativeWidth(1)
		button:SetHeight(30)
		button:SetCallback("OnClick", function() 
			if not HerbSpecializationsframe then
				SaveSettings()
				AceGUI:Release(Herbframe) 
				Herbframe = nil
				DrawHerbSpecialization()
			end
		end)
		Herbframe:AddChild(button)
	end
	
	local button = AceGUI:Create("Button")
	button:SetText("Reset priority")
	button:SetRelativeWidth(1)
	button:SetHeight(20)
	button:SetCallback("OnClick", function() 
		for v, k in pairs(nodes) do
			if k.Art == "h" then  
				k.Prio = 10 
			end
		end				
		SaveSettings()
		AceGUI:Release(Herbframe) 
		DrawHerbOptions()
	end)
	Herbframe:AddChild(button)	
	
	local heading = AceGUI:Create("Heading")
	heading:SetText("Set global priority from 1(highest) to 10(lowest) or check the box to ignore Herb Node")
	heading:SetRelativeWidth(1)
	Herbframe:AddChild(heading)

    lastvrb = false
    for v, k in pairs(nodes) do
        if (not lastvrb or (lastvrb ~= k.VRB)) and k.Art == "h" then     
            lastvrb = k.VRB
            local checkbox = AceGUI:Create("CheckBox")
            checkbox:SetValue(k.Chk)
            checkbox:SetType("checkbox")
            checkbox:SetLabel(k.name)
            checkbox:SetUserData("nam", k.name)
            checkbox:SetRelativeWidth(0.25)
            checkbox:SetCallback("OnValueChanged",function()   
                store = checkbox:GetUserData("nam")              
                for v, k in pairs(nodes) do
                    if k.name == store then  
                        if (checkbox:GetValue()) then
                            k.Chk = true
                        else
                            k.Chk = false
                        end
                    end
                end
				SaveSettings()
            end)
            Herbframe:AddChild(checkbox)
			local dropdown = AceGUI:Create("Dropdown")
			--dropdown:SetLabel(":")
			dropdown:SetRelativeWidth(0.07)
			dropdown:SetHeight(15)
			dropdown:SetList{"1","2","3","4","5","6","7","8","9","10"}
			dropdown:SetValue(k.Prio)
			dropdown:SetUserData("pnam", k.name)
			dropdown:SetCallback("OnValueChanged",function() 
				pstore = dropdown:GetUserData("pnam") 
				for v, k in pairs(nodes) do
                    if k.name == pstore then  
                        k.Prio = tonumber(dropdown:GetValue()) 
                    end
                end				
				SaveSettings()
			end)
			Herbframe:AddChild(dropdown)
        end
    end
end

local function DrawOreOptions()
	Oreframe = AceGUI:Create("Frame")
	Oreframe:SetTitle("Mining Options")
	Oreframe:SetWidth(900)
	Oreframe:SetHeight(550)
	Oreframe:SetPoint("TOPLEFT",350,0)
	Oreframe:SetStatusText("Tinkr version:"..vers)
	Oreframe:SetCallback("OnClose", function(widget) AceGUI:Release(widget) SaveSettings() 
		Oreframe = nil
	end)
	Oreframe:SetLayout("Flow")
	
	local heading = AceGUI:Create("Heading")
	--heading:SetText("Other Ignoring")
	heading:SetRelativeWidth(1)
	Oreframe:AddChild(heading)  	
	
	local checkbox = AceGUI:Create("CheckBox")
    checkbox:SetValue(IgnoreTWWm)
    checkbox:SetType("checkbox")
    checkbox:SetLabel("Ignore Mining")
    checkbox:SetRelativeWidth(0.17)
    checkbox:SetCallback("OnValueChanged",function() 
        if (checkbox:GetValue()) then
            IgnoreTWWm = true                    
        else
            IgnoreTWWm = false
        end
        for v, k in pairs(nodes) do
            if k.Art == "m" then  
                if (checkbox:GetValue()) then
                    k.Chk = true                    
                else
                    k.Chk = false
                end
            end
        end
		SaveSettings()
		AceGUI:Release(Oreframe) 
		DrawOreOptions()
    end)
    Oreframe:AddChild(checkbox)  
	
	local editbox = AceGUI:Create("EditBox")
	editbox:SetLabel("Ignore Range")
	editbox:SetText(MMobrange)
	editbox:SetRelativeWidth(0.11)
	editbox:SetHeight(40)
	editbox:SetCallback("OnEnterPressed", function(widget, event, text) 
		if text == nil then
			MMobrange = 30
		else
			MMobrange = tonumber(text)
		end
		SaveSettings()
	end)
	Oreframe:AddChild(editbox)

	local checkbox = AceGUI:Create("CheckBox")
	checkbox:SetValue(MAvoidMobs)
	checkbox:SetType("checkbox")
	checkbox:SetLabel("Skip near aggro mobs")
	checkbox:SetRelativeWidth(0.20)
	checkbox:SetCallback("OnValueChanged",function()		
		if (checkbox:GetValue()) then
			MAvoidMobs = true
			print("Avoid ore near aggro mobs enable")
		else
			MAvoidMobs = false
			print("Avoid ore near aggro mobs disable") 
		end
		SaveSettings()
	end)
	Oreframe:AddChild(checkbox)
	
	local checkbox = AceGUI:Create("CheckBox")
	checkbox:SetValue(MAvoidElite)
	checkbox:SetType("checkbox")
	checkbox:SetLabel("Skip near elite mobs")
	checkbox:SetRelativeWidth(0.20)
	checkbox:SetCallback("OnValueChanged",function()		
		if (checkbox:GetValue()) then
			MAvoidElite = true
			print("Avoid ore near elite mobs enable")
		else
			MAvoidElite = false
			print("Avoid ore near elite mobs disable") 
		end
		SaveSettings()
	end)
	Oreframe:AddChild(checkbox)	
	
	if LoadExpansion == "The War Within" or LoadExpansion == "Dragonflight" then
		local checkbox = AceGUI:Create("CheckBox")
		checkbox:SetValue(OverOrb)
		checkbox:SetType("checkbox")
		checkbox:SetLabel("Overload Ore")
		checkbox:SetRelativeWidth(0.23)
		checkbox:SetCallback("OnValueChanged",function()
			if (checkbox:GetValue()) then
				OverOrb = true
				print("Overload Ore enable") 
			else
				OverOrb = false
				print("Overload Ore disable") 
			end
			SaveSettings()
		end)
		Oreframe:AddChild(checkbox)
	end
	
	local button = AceGUI:Create("Button")
	button:SetText("Mining Specializations")
	button:SetRelativeWidth(1)
	button:SetHeight(30)
	button:SetCallback("OnClick", function() 
		if not OreSpecializationsframe then
			SaveSettings()
			AceGUI:Release(Oreframe) 
			Oreframe = nil
			DrawOreSpecialization()
		end
	end)
	Oreframe:AddChild(button)
	
	local button = AceGUI:Create("Button")
	button:SetText("Reset priority")
	button:SetRelativeWidth(1)
	button:SetHeight(20)
	button:SetCallback("OnClick", function() 
		for v, k in pairs(nodes) do
			if k.Art == "m" then  
				k.Prio = 10 
			end
		end				
		SaveSettings()
		AceGUI:Release(Oreframe) 
		DrawOreOptions()
	end)
	Oreframe:AddChild(button)	

	local heading = AceGUI:Create("Heading")
	heading:SetText("Set global priority from 1(highest) to 10(lowest) or check the box to ignore Mining Nodes")
	heading:SetRelativeWidth(1)
	Oreframe:AddChild(heading)  

	lastvrb = false
    for v, k in pairs(nodes) do
        if (not lastvrb or (lastvrb ~= k.VRB)) and k.Art == "m" then     
            lastvrb = k.VRB
            local checkbox = AceGUI:Create("CheckBox")
            checkbox:SetValue(k.Chk)
            checkbox:SetType("checkbox")
            checkbox:SetLabel(k.name)
            checkbox:SetUserData("nam", k.name)
            checkbox:SetRelativeWidth(0.25)
            checkbox:SetCallback("OnValueChanged",function()   
                store = checkbox:GetUserData("nam")              
                for v, k in pairs(nodes) do
                    if k.name == store then  
                        if (checkbox:GetValue()) then
                            k.Chk = true
                        else
                            k.Chk = false
                        end
                    end
                end
				SaveSettings()
            end)
            Oreframe:AddChild(checkbox)
			local dropdown = AceGUI:Create("Dropdown")
			--dropdown:SetLabel(":")
			dropdown:SetRelativeWidth(0.07)
			dropdown:SetHeight(15)
			dropdown:SetList{"1","2","3","4","5","6","7","8","9","10"}
			dropdown:SetValue(k.Prio)
			dropdown:SetUserData("pnam", k.name)
			dropdown:SetCallback("OnValueChanged",function() 
				pstore = dropdown:GetUserData("pnam") 
				for v, k in pairs(nodes) do
                    if k.name == pstore then  
                        k.Prio = tonumber(dropdown:GetValue()) 
                    end
                end				
				SaveSettings()
			end)
			Oreframe:AddChild(dropdown)
        end       
    end
end

local function DrawFishOptions()
	Fishframe = AceGUI:Create("Frame")
	Fishframe:SetTitle("Fishing Options")
	Fishframe:SetWidth(900)
	Fishframe:SetHeight(550)
	Fishframe:SetPoint("TOPLEFT",350,0)
	Fishframe:SetStatusText("Tinkr version:"..vers)
	Fishframe:SetCallback("OnClose", function(widget) AceGUI:Release(widget) SaveSettings() 
		Fishframe = nil
	end)
	Fishframe:SetLayout("Flow")
	
	local heading = AceGUI:Create("Heading")
	--heading:SetText("Other Ignoring")
	heading:SetRelativeWidth(1)
	Fishframe:AddChild(heading)  	
	
	local checkbox = AceGUI:Create("CheckBox")
    checkbox:SetValue(IgnoreTWWf)
    checkbox:SetType("checkbox")
    checkbox:SetLabel("Ignore Fishing")
    checkbox:SetRelativeWidth(0.17)
    checkbox:SetCallback("OnValueChanged",function() 
        if (checkbox:GetValue()) then
            IgnoreTWWf = true
        else
            IgnoreTWWf = false
        end
        for v, k in pairs(nodes) do
            if k.Art == "f" then  
                if (checkbox:GetValue()) then
                    k.Chk = true
                else
                    k.Chk = false
                end
            end
        end
		SaveSettings()
		AceGUI:Release(Fishframe) 
		DrawFishOptions()
    end)
    Fishframe:AddChild(checkbox)
	
	local editbox = AceGUI:Create("EditBox")
	editbox:SetLabel("Ignore Range")
	editbox:SetText(FMobrange)
	editbox:SetRelativeWidth(0.11)
	editbox:SetHeight(40)
	editbox:SetCallback("OnEnterPressed", function(widget, event, text) 
		if text == nil then
			FMobrange = 30
		else
			FMobrange = tonumber(text)
		end
		SaveSettings()
	end)
	Fishframe:AddChild(editbox)

	local checkbox = AceGUI:Create("CheckBox")
	checkbox:SetValue(FAvoidMobs)
	checkbox:SetType("checkbox")
	checkbox:SetLabel("Skip near aggro mobs")
	checkbox:SetRelativeWidth(0.20)
	checkbox:SetCallback("OnValueChanged",function()		
		if (checkbox:GetValue()) then
			FAvoidMobs = true
			print("Avoid fish near aggro mobs enable")
		else
			FAvoidMobs = false
			print("Avoid fish near aggro mobs disable") 
		end
		SaveSettings()
	end)
	Fishframe:AddChild(checkbox)
	
	local checkbox = AceGUI:Create("CheckBox")
	checkbox:SetValue(FAvoidElite)
	checkbox:SetType("checkbox")
	checkbox:SetLabel("Skip near elite mobs")
	checkbox:SetRelativeWidth(0.20)
	checkbox:SetCallback("OnValueChanged",function()		
		if (checkbox:GetValue()) then
			FAvoidElite = true
			print("Avoid fish near elite mobs enable")
		else
			FAvoidElite = false
			print("Avoid fish near elite mobs disable") 
		end
		SaveSettings()
	end)
	Fishframe:AddChild(checkbox)
	
	if LoadExpansion == "The War Within" then
		local checkbox = AceGUI:Create("CheckBox")
		checkbox:SetValue(LetGhoul)
		checkbox:SetType("checkbox")
		checkbox:SetLabel("Collect Cursed Ghoulfish")
		checkbox:SetRelativeWidth(0.23)
		checkbox:SetCallback("OnValueChanged",function()		
			if (checkbox:GetValue()) then
				LetGhoul = true
				print("Cursed Ghoulfish will collected")
			else
				LetGhoul = false
				print("Cursed Ghoulfish will not collected") 
			end
			SaveSettings()
		end)
		Fishframe:AddChild(checkbox)
	end
	
	local button = AceGUI:Create("Button")
	button:SetText("Reset priority")
	button:SetRelativeWidth(1)
	button:SetHeight(40)
	button:SetCallback("OnClick", function() 
		for v, k in pairs(nodes) do
			if k.Art == "f" then  
				k.Prio = 10 
			end
		end				
		SaveSettings()
		AceGUI:Release(Fishframe) 
		DrawFishOptions()
	end)
	Fishframe:AddChild(button)
	
	local heading = AceGUI:Create("Heading")
	heading:SetText("Set global priority from 1(highest) to 10(lowest) or check the box to ignore Fishing Pools")
	heading:SetRelativeWidth(1)
	Fishframe:AddChild(heading)  
    
    lastvrb = false
    for v, k in pairs(nodes) do
        if (not lastvrb or (lastvrb ~= k.VRB)) and k.Art == "f" then     
            lastvrb = k.VRB
            local checkbox = AceGUI:Create("CheckBox")
            checkbox:SetValue(k.Chk)
            checkbox:SetType("checkbox")
            checkbox:SetLabel(k.name)
            checkbox:SetUserData("nam", k.name)
            checkbox:SetRelativeWidth(0.25)
            checkbox:SetCallback("OnValueChanged",function()   
                store = checkbox:GetUserData("nam")              
                for v, k in pairs(nodes) do
                    if k.name == store then  
                        if (checkbox:GetValue()) then
                            k.Chk = true
                        else
                            k.Chk = false
                        end
                    end
                end
				SaveSettings()
            end)
            Fishframe:AddChild(checkbox)
			local dropdown = AceGUI:Create("Dropdown")
			--dropdown:SetLabel(":")
			dropdown:SetRelativeWidth(0.07)
			dropdown:SetHeight(15)
			dropdown:SetList{"1","2","3","4","5","6","7","8","9","10"}
			dropdown:SetValue(k.Prio)
			dropdown:SetUserData("pnam", k.name)
			dropdown:SetCallback("OnValueChanged",function() 
				pstore = dropdown:GetUserData("pnam") 
				for v, k in pairs(nodes) do
                    if k.name == pstore then  
                        k.Prio = tonumber(dropdown:GetValue()) 
                    end
                end				
				SaveSettings()
			end)
			Fishframe:AddChild(dropdown)
        end
    end

end


local function DrawRouteOtions()
	Routeframe = AceGUI:Create("Frame")
	Routeframe:SetTitle("Route Options")
	Routeframe:SetWidth(350)
	Routeframe:SetHeight(250)
	Routeframe:SetPoint("TOPLEFT",350,0)
	Routeframe:SetStatusText("Tinkr version:"..vers)
	Routeframe:SetCallback("OnClose", function(widget) AceGUI:Release(widget) 
		Routeframe = nil
	end)
	Routeframe:SetLayout("Flow")	

	local editbox = AceGUI:Create("EditBox")
	editbox:SetLabel("Create Route")
	editbox:SetRelativeWidth(0.475)
	editbox:SetCallback("OnEnterPressed", function(widget, event, text) 
		NewRoute = text    
	end)
	Routeframe:AddChild(editbox)

	local editbox = AceGUI:Create("EditBox")
	editbox:SetLabel("Points distance")
	editbox:SetRelativeWidth(0.475)
	editbox:SetCallback("OnEnterPressed", function(widget, event, text) 
		farmradius = tonumber(text)    
	end)
	Routeframe:AddChild(editbox)

	local button = AceGUI:Create("Button")
	button:SetText("Start record")
	button:SetRelativeWidth(0.47)
	button:SetHeight(40)
	button:SetCallback("OnClick", function() 
		if not NewRoute then 
			print("Route name is empty! Enter the name for the route") 
			return
		elseif not farmradius then
			print("Distance field is empty! Set distance for points") 
			return
		end
		LastPoint = nil
		print("Start record")
		Pathing = true 
		CreateRoute()
	end)
	Routeframe:AddChild(button)

	local button = AceGUI:Create("Button")
	button:SetText("Save")
	button:SetRelativeWidth(0.47)
	button:SetHeight(40)
	button:SetCallback("OnClick", function() 
		table.insert(Points, {px, py, pz, farmradius})
		WriteFile("/scripts/AKH/route/"..NewRoute..".json", '['..px..','.. py..','.. pz..',' ..farmradius ..']]}', true)
		print("Route created")
		LoadRoute = NewRoute
		SaveSettings()
		State = "PAUSE"
		LastPoint = nil
		Pathing = false
	end)
	Routeframe:AddChild(button)

	local dropdown = AceGUI:Create("Dropdown")
	dropdown:SetLabel("Select Farm Route:")
	dropdown:SetRelativeWidth(0.47)
	local rutspath = '/scripts/AKH/route/'
	local ruts = ListFiles(rutspath)
	local RoutsList ={}
	for i=1, #ruts do 
		rname = string.sub(ruts[i],1,#ruts[i] -5)
		table.insert(RoutsList,rname)
	end
	local dvalue
	for i=1, #RoutsList do 
		if RoutsList[i] == LoadRoute then
			dvalue = i
		end
	end  
	dropdown:SetList(RoutsList)	
	dropdown:SetValue(tonumber(dvalue))
	dropdown:SetCallback("OnValueChanged",function() 
		NRoute = dropdown:GetValue()
		LoadRoute = RoutsList[NRoute]
		SaveSettings()
	end)
	Routeframe:AddChild(dropdown)

	local button = AceGUI:Create("Button")
	button:SetText("Load Route")
	button:SetWidth(70)
	button:SetHeight(40)
	button:SetCallback("OnClick", function() 
		Points = {}
		local SpotFile = ReadFile('/scripts/AKH/route/'..LoadRoute..'.json')
		local Spot = JsonDecode(SpotFile)
		Map = Spot.Continent    
		Points = Spot.Points
	end)
	Routeframe:AddChild(button)	
	
	local button = AceGUI:Create("Button")
	button:SetText("Edit Route")
	button:SetWidth(70)
	button:SetHeight(40)
	button:SetCallback("OnClick", function() 
		if #Points < 1 then
			print("Route is empty")  
		else
			if not Editorframe then
				Points = {}
				local SpotFile = ReadFile('/scripts/AKH/route/'..LoadRoute..'.json')
				local Spot = JsonDecode(SpotFile)
				Map = Spot.Continent    
				Points = Spot.Points
				Liste = Points
				CurrentListe = "Route"
				DrawEditor()
			end
		end
	end)
	Routeframe:AddChild(button)	
end
local function DrawAKHFrame()
	if firstini then
		k:Show() 
		firstini = false
		return
	end
	local frame = AceGUI:Create("Frame")
	frame:SetTitle("Gatherer")
	frame:SetWidth(400)  -- Changed width
	frame:SetHeight(350) -- Changed height
	frame:SetPoint("TOPLEFT",0,0)
	frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) 
		k:Show()  
	end)
	frame:SetLayout("Flow")
	
	local heading = AceGUI:Create("Heading")
	heading:SetText("The War Within Gathering Settings")
	heading:SetRelativeWidth(1)
	frame:AddChild(heading)
	
	-- Removed expansion dropdown since we're only using TWW
	LoadExpansion = "The War Within"
	nodes = TWW
	ExpObj = "TWW"
	
	local editbox = AceGUI:Create("EditBox")
	editbox:SetLabel("Gathering Range")
	editbox:SetText(Gatherrange)
	editbox:SetRelativeWidth(0.45)
	editbox:SetCallback("OnEnterPressed", function(widget, event, text) 
		Gatherrange = text 
		SaveSettings()   
	end)
	frame:AddChild(editbox)

	local spacer = AceGUI:Create("SimpleGroup")
	spacer:SetFullWidth(true)
	spacer:SetHeight(10)
	frame:AddChild(spacer)

	local button = AceGUI:Create("Button")
	button:SetText("Begin Gathering")  -- Changed text
	button:SetRelativeWidth(0.45)
	button:SetHeight(50)
	button:SetCallback("OnClick", function() 
		local Curmap = select(8, GetInstanceInfo())
		Lastloot = GetTime()
		if Mail and not TimeToSendMail then
			TimeToSendMail = time()
		end
		if GuildBank and not TimeToUseGB then
			TimeToUseGB = time()+300
		end
		if not LoadRoute then
			print("Please load or create a route first.")
			return
		elseif Curmap ~= Map then
			print("Current route doesn't match this map.")
			return
		elseif not Gatherrange then
			print("Gathering range not configured.")
			return
		end
		
		-- Mount check logic remains the same
		local mounts = C_MountJournal.GetMountIDs()
		for _, v in pairs(mounts) do
			local creatureName, spellID, icon, active, isUsable, sourceType, isFavorite, isFactionSpecific, faction, isFiltered, isCollected, mountID = C_MountJournal.GetMountInfoByID(v)
			if active then
				local creatureDisplayID, descriptionText, sourceText, isSelfMount, mountType = C_MountJournal.GetMountInfoExtraByID(mountID)
				if mountType == 229 
				or mountType == 238 
				or mountType == 247 
				or mountType == 248 
				or mountType == 402 
				or mountType == 407 
				or mountType == 424 
				or mountType == 436 
				or mountType == 437 
				or mountType == 442 
				or mountType == 444 
				or mountType == 445 then
					MountTyp = "FLYMOUNT"
				else
					if not Druid and IsMounted() then
						Dismount()
					end
				end
			end
		end
		
		if GetCVar("autointeract") == 0 then
			SetCVar("autointeract", 1)
		end
		print("Gathering Started")        
		SaveSettings()  
		AceGUI:Release(frame) 
		k:Show()
		if not IsOutdoors("player") and not UnitIsDeadOrGhost("player") then
			HSwalk()
		else 
			State = "IDLE" 
		end
	end)
	frame:AddChild(button)

	local button = AceGUI:Create("Button")
	button:SetText("Stop")
	button:SetRelativeWidth(0.45)
	button:SetHeight(50)
	button:SetCallback("OnClick", function() 
		print("Gathering Stopped")
		if moving then
			Eval('ToggleAutoRun()',"")
			moving = nil
			DirToReach = nil
		end
		if rechtssdreh then
			Eval('TurnRightStop()',"")
			rechtssdreh = nil
		end
		if linksdreh then
			Eval('TurnLeftStop()',"")
			linksdreh = nil
		end
		State = "PAUSE"
	end)
	frame:AddChild(button)

	local editbox = AceGUI:Create("EditBox")
	editbox:SetLabel("Blacklisted radius")
	editbox:SetText(BlacklRadius)
	editbox:SetWidth(100)
	editbox:SetHeight(50)
	editbox:SetCallback("OnEnterPressed", function(widget, event, text) 
		BlacklRadius = tonumber(text)    
		SaveSettings()  
	end)
	frame:AddChild(editbox)

	local button = AceGUI:Create("Button")
	button:SetText("Blacklist this place")
	button:SetWidth(100)
	button:SetHeight(40)
	button:SetCallback("OnClick", function() 
		if not BlacklRadius then
			print("set radius first")  
		else
			SaveBlacklistedPos(px, py, pz, BlacklRadius)
		end
	end)
	frame:AddChild(button)
	
	local button = AceGUI:Create("Button")
	button:SetText("Edit Blacklist")
	button:SetWidth(100)
	button:SetHeight(40)
	button:SetCallback("OnClick", function() 
		if #BlacklistedPlace < 1 then
			print("Blacklist is empty")  
		else
			if not Editorframe then
				Liste = BlacklistedPlace
				CurrentListe = "Black"
				DrawEditor()
			end
		end
	end)
	frame:AddChild(button)

	local editbox = AceGUI:Create("EditBox")
	editbox:SetLabel("Whitelisted radius")
	editbox:SetText(WhitelRadius)
	editbox:SetWidth(100)
	editbox:SetHeight(50)
	editbox:SetCallback("OnEnterPressed", function(widget, event, text) 
		WhitelRadius = tonumber(text)    
		SaveSettings()  
	end)
	frame:AddChild(editbox)

	local button = AceGUI:Create("Button")
	button:SetText("Whitelist this place")
	button:SetWidth(100)
	button:SetHeight(40)
	button:SetCallback("OnClick", function() 
		if not WhitelRadius then
			print("set radius first")  
		else
			SaveWhitelistedPos(px, py, pz, WhitelRadius)
		end
	end)
	frame:AddChild(button)
	
	local button = AceGUI:Create("Button")
	button:SetText("Edit Whitelist")
	button:SetWidth(100)
	button:SetHeight(40)
	button:SetCallback("OnClick", function() 
		if #WhitelistedPlace < 1 then
			print("Whitelist is empty")  
		else
			if not Editorframe then
				Liste = WhitelistedPlace
				CurrentListe = "White"
				DrawEditor()
			end
		end
	end)
	frame:AddChild(button)

	local button = AceGUI:Create("Button")
	button:SetText("General Options")
	button:SetWidth(100)
	button:SetHeight(40)
	button:SetCallback("OnClick", function() 
		if not Generalframe then
			DrawGeneralOtions()
		end
	end)
	frame:AddChild(button)

	local button = AceGUI:Create("Button")
	button:SetText("Route Options")
	button:SetWidth(100)
	button:SetHeight(40)
	button:SetCallback("OnClick", function() 
		if not Routeframe then
			DrawRouteOtions()
		end
	end)
	frame:AddChild(button)

	local button = AceGUI:Create("Button")
	button:SetText("Treasure Options")
	button:SetWidth(100)
	button:SetHeight(40)
	button:SetCallback("OnClick", function()
		if Oreframe then
			AceGUI:Release(Oreframe) 
		elseif Fishframe then
			AceGUI:Release(Fishframe) 
		elseif Herbframe then
			AceGUI:Release(Herbframe) 
		end
		if not Gatherframe then			
			DrawGatherOptions()
		else
			AceGUI:Release(Gatherframe) 
		end
	end)
	frame:AddChild(button)
	
	local button = AceGUI:Create("Button")
	button:SetText("Herbalism Options")
	button:SetWidth(100)
	button:SetHeight(40)
	button:SetCallback("OnClick", function()
		if Oreframe then
			AceGUI:Release(Oreframe) 
		elseif Fishframe then
			AceGUI:Release(Fishframe) 
		elseif Gatherframe then
			AceGUI:Release(Gatherframe) 
		end
		if not Herbframe then
			DrawHerbOptions()
		else
			AceGUI:Release(Herbframe) 
		end
	end)
	frame:AddChild(button)
	
	local button = AceGUI:Create("Button")
	button:SetText("Mining Options")
	button:SetWidth(100)
	button:SetHeight(40)
	button:SetCallback("OnClick", function()
		if Herbframe then
			AceGUI:Release(Herbframe) 
		elseif Fishframe then
			AceGUI:Release(Fishframe) 
		elseif Gatherframe then
			AceGUI:Release(Gatherframe) 
		end
		if not Oreframe then
			DrawOreOptions()
		else
			AceGUI:Release(Oreframe) 
		end
	end)
	frame:AddChild(button)
	
	local button = AceGUI:Create("Button")
	button:SetText("Fishing Options")
	button:SetWidth(100)
	button:SetHeight(40)
	button:SetCallback("OnClick", function()
		if Oreframe then
			AceGUI:Release(Oreframe) 
		elseif Herbframe then
			AceGUI:Release(Herbframe) 
		elseif Gatherframe then
			AceGUI:Release(Gatherframe) 
		end
		if not Fishframe then
			DrawFishOptions()
		else
			AceGUI:Release(Fishframe) 
		end
	end)
	frame:AddChild(button)
end

f1 = CreateFrame("Frame",nil,UIParent)
f1:SetWidth(100) 
f1:SetHeight(100) 
f1:SetAlpha(0.4)
f1:SetPoint("CENTER",0,150)
f1.text = f1:CreateFontString(nil,"ARTWORK") 
f1.text:SetFont("Fonts\\ARIALN.ttf", 20, "OUTLINE")
f1.text:SetTextColor(204,255,204)
f1.text:SetPoint("CENTER",0,0)
f1:Show()  

-- Spot‑Fishing Toggle
local fishToggle = Aurora:AddGlobalToggle({
    label   = "Fishing",                         -- up to 11 characters
    var     = "spot_fishing_toggle",             -- unique saved key
    icon    = "Interface/Icons/Trade_Fishing",
    tooltip = "Enable spot‑fishing mode",
    onClick = function(enabled)
        if not enabled then return end
        -- your original fishing logic:
        for l = 1, 15 do
            for i = 0, 360, 5 do
                local nowater = false
                local Rota = ObjectRotation("player") + math.rad(i)
                local XL, YL, ZL = RotateVector(px, py, pz+4, Rota, l)
                local hitx, hity, hitz = TraceLine(XL, YL, ZL, XL, YL, ZL-24, 0x10000)
                if hitx ~= 0 then
                    local dist = FastDistance(px, py, pz, hitx, hity, hitz)
                    if dist <= 14 and dist >= 11 then
                        for j = 0, 360, 5 do
                            local Rota1 = ObjectRotation("player") + math.rad(j)
                            local XL1, YL1, ZL1 = RotateVector(hitx, hity, hitz+1, Rota1, 4)
                            local hx1, hy1, hz1 = TraceLine(XL1, YL1, ZL1, XL1, YL1, ZL1-1, hitFlagsWithoutWat)
                            if hx1 ~= 0 then
                                nowater = true
                                break
                            end
                        end
                        if not nowater then
                            local angle, pitch = CalculateAngleAndPitchToPoint(
                                {x=px,y=py,z=pz},
                                {x=hitx,y=hity,z=hitz}
                            )
                            FaceDirection(angle, true)
                            State = "SPOTFISHING"
                            SpotFishi()
                            return
                        end
                    end
                end
            end
        end
        print("You are too far away from water")
        fishToggle:SetValue(false)
    end,
})



-- Start/Stop Toggle
local startToggle = Aurora:AddGlobalToggle({
    label   = "Start",
    var     = "gatherer_start_toggle",
    icon    = "Interface/Icons/Spell_Nature_Swiftness",
    tooltip = "Start/Stop gathering route",
    onClick = function(enabled)
        local Curmap = select(8, GetInstanceInfo())
        
        if enabled then
            -- Start functionality
            if not LoadRoute then
                print("Route not loaded. First load or create a route.")
                startToggle:SetValue(false)
                return
            elseif Curmap ~= Map then
                print("Wrong route for this map")
                startToggle:SetValue(false)
                return
            elseif not Gatherrange then
                print("Gatherrange not set. Set gatherrange.")
                startToggle:SetValue(false)
                return
            end

            Lastloot = GetTime()
            if Mail and not TimeToSendMail then
                TimeToSendMail = time()
            end
            if GuildBank and not TimeToUseGB then
                TimeToUseGB = time() + 300
            end

            -- Mount check and setup
            for _, v in pairs(C_MountJournal.GetMountIDs()) do
                local _, _, _, active, _, _, _, _, _, _, _, mountID = C_MountJournal.GetMountInfoByID(v)
                if active then
                    local _, _, _, _, mountType = C_MountJournal.GetMountInfoExtraByID(mountID)
                    if mountType == 229 or mountType == 238 or mountType == 247
                       or mountType == 248 or mountType == 402 or mountType == 407
                       or mountType == 424 or mountType == 436 or mountType == 437
                       or mountType == 442 or mountType == 444 or mountType == 445 then
                        MountTyp = "FLYMOUNT"
                    else
                        if not Druid and IsMounted() then
                            Dismount()
                        end
                    end
                end
            end

            if GetCVar("autointeract") == "0" then
                SetCVar("autointeract", "1")
            end

            print("Starting gathering route")
            SaveSettings()
            if not IsOutdoors("player") and not UnitIsDeadOrGhost("player") then
                HSwalk()
            else
                State = "IDLE"
            end
        else
            -- Stop functionality
            print("Stopping gathering route")
            if moving then
                Eval("ToggleAutoRun()","")
                moving = nil
                DirToReach = nil
            end
            if rechtssdreh then
                Eval("TurnRightStop()","")
                rechtssdreh = nil
            end
            if linksdreh then
                Eval("TurnLeftStop()","")
                linksdreh = nil
            end
            Eval("MoveForwardStop()","")
            if not IsFlying() then
                chifmv = CheckifHumanMove()
            end
            if Pitchdownrun then
                Eval("PitchDownStop()","")
                Pitchdownrun = nil
            end
            fishpool, tarobject, warchest, foundlandplace, foundpoollandplace = nil
            xxp, yyp, zzp = nil, nil, nil
            State = "PAUSE"
            SaveSettings()
        end
    end,
})



function SendMailtoSubj(count)
	if SendMailFrame:IsVisible() then
		local cnt = count
		local randomizer0 = math.random(0,1)
		local randomizer1 = math.random(2,5)
		local numBags = 5
		for i = 0, numBags do
			local numBagSlots = C_Container.GetContainerNumSlots(i)
			for j = 0, numBagSlots do
				if cnt < 12 then
					local itemID = C_Container.GetContainerItemID(i, j)
					if itemID ~= nil then
						local containerInfo = C_Container.GetContainerItemInfo(i, j)
						local quality = containerInfo.quality
						local isLocked = containerInfo.isLocked
						local bindType = select(14, GetItemInfo(itemID))						
						if itemID ~= 212308
						and itemID ~= 124671
						and itemID ~= 224583
						and itemID ~= 212309
						and itemID ~= 224838
						and itemID ~= 224264
						and itemID ~= 224835
						and itemID ~= 224584
						and itemID ~= 224265
						and itemID ~= 224818
						and itemID ~= 224817
						and itemID ~= 212310 
						and itemID ~= 222507 
						and itemID ~= 222506 
						and itemID ~= 212314 
						and itemID ~= 212315 
						and itemID ~= 212316 
						and itemID ~= 222505 
						and quality ~= 0 
						and bindType == 0
						and not isLocked then
							C_Container.UseContainerItem(i, j)
							cnt = cnt + 1
							C_Timer.After(randomizer0, function() 
								if State ~= "PAUSE" then
									SendMailtoSubj(cnt)
								end
							end)						
							return
						end
					end	
				end
			end					
		end
		if cnt == 12 then		
			C_Timer.After(2, function() 
				if State ~= "PAUSE" then
					print("Send Mail to: " ..MailChar)
					SendMail(MailChar,  SendMailSubjectEditBox:GetText())
					C_Timer.After(randomizer1, function() 
						if State ~= "PAUSE" then
							SendMailtoSubj(0)
						end
					end)
				end
			end)			
			return
		elseif cnt > 0 then
			C_Timer.After(2, function() 
				if State ~= "PAUSE" then
					print("Send Mail to: " ..MailChar)
					SendMail(MailChar, SendMailSubjectEditBox:GetText())
					CloseMail()
					TimeToSendMail = MailTime * 60 + time()
					SaveSettings()
					x,y,z = nil,nil,nil
					if State ~= "PAUSE" then
						State = "IDLE"
					end
				end
			end)				
			mailing = false 
		elseif cnt == 0 then
			CloseMail()
			TimeToSendMail = MailTime * 60 + time()
			SaveSettings()
			x,y,z = nil,nil,nil
			State = "IDLE"
		end
	end
end

local function GBInteract()
	local objects = Objects(8) --Objects()
	for v,k in pairs(objects) do
		if ObjectId(k) == 206603 then
			ObjectInteract(k)
			print('Guild Chest Interact')
			return
		end		
	end
end

local function fitItemGuildBank(tab, searchItemLink, itemStackCount, bagsCount)
    local itemSlot = -1
    local i = 1
    while (i <= 98 and itemSlot == -1) do
        local itemLink = GetGuildBankItemLink(tab, i)
        local texture, amount = GetGuildBankItemInfo(tab, i)

        if ((itemLink == searchItemLink) and ((amount + bagsCount) < itemStackCount)) or (amount == 0) then
            itemSlot = i
        end
        i = i + 1
    end
    return itemSlot
end
local function DepositReagents()
	if GuildBank then
		local DeptimeElapsed = (GetTime() - LastDepTime) 
		if DeptimeElapsed < 10 then
			local Banktabs = GetNumGuildBankTabs()
			local summslot = 0
			for i = 1, Banktabs do
				local guildBankTab = i
				if i == 1 then
					GuildBankTab1.Button:Click()
				elseif i == 2 then
					GuildBankTab2.Button:Click()
				elseif i == 3 then
					GuildBankTab3.Button:Click()
				elseif i == 4 then
					GuildBankTab4.Button:Click()
				elseif i == 5 then
					GuildBankTab5.Button:Click()
				elseif i == 6 then
					GuildBankTab6.Button:Click()
				elseif i == 7 then
					GuildBankTab7.Button:Click()
				elseif i == 8 then
					GuildBankTab8.Button:Click()
				end
				local name, icon, isViewable, canDeposit, numWithdrawals, remainingWithdrawals = GetGuildBankTabInfo(guildBankTab)
				if canDeposit or IsGuildLeader(UnitName("player")) then
					local numBags = 5
					for i = 0, numBags do
						local numBagSlots1 = C_Container.GetContainerNumSlots(i)
						for j = 0, numBagSlots1 do
							local itemID = C_Container.GetContainerItemID(i, j)
							if itemID ~= nil then
								local containerInfo = C_Container.GetContainerItemInfo(i, j)
								local quality = containerInfo.quality
								local isLocked = containerInfo.isLocked
								local bindType = select(14, GetItemInfo(itemID))						
								if itemID ~= 212308
								and itemID ~= 124671
								and itemID ~= 224583
								and itemID ~= 212309
								and itemID ~= 224838
								and itemID ~= 224264
								and itemID ~= 224835
								and itemID ~= 224584
								and itemID ~= 224265
								and itemID ~= 224818
								and itemID ~= 224817
								and itemID ~= 212310 
								and itemID ~= 222507 
								and itemID ~= 222506 
								and itemID ~= 212314 
								and itemID ~= 212315 
								and itemID ~= 212316 
								and itemID ~= 222505 
								and quality ~= 0 
								and (bindType == 0 or bindType == 2)
								and not isLocked then
									local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType,
									itemStackCount, itemEquipLoc, itemTexture, sellPrice, classID, subclassID, bindType,
									expacID, setID, isCraftingReagent = GetItemInfo(itemID)
									local count = GetItemCount(itemID, false, false)
									local guildBankItemSlot = fitItemGuildBank(guildBankTab, itemLink, itemStackCount, count)
									if guildBankItemSlot > 0 then
										C_Container.UseContainerItem(i, j)
										C_Timer.After(1, DepositReagents)
										return
									end							
								end
							end
						end					
					end
				end
			end	
		end
		CloseGuildBankFrame()
		TimeToUseGB = GBafterTime * 3600 + time()
		SaveSettings()
		Stashing = nil
		State = "IDLE"
	end	
end
local function MammutInteract()
	if (Mammut or MammutSell) and Mammutmounted then
		local objects = Objects(5)
		for v,k in pairs(objects) do
			if ObjectId(k) == 32641
			or ObjectId(k) == 32639 then
				ObjectInteract(k)
				if MerchantFrame:IsVisible() then
					if Mammut == true and Repairing == true then
						if GuildRepair then 
							RepairAllItems(1)
						else
							RepairAllItems()
						end
						Repairing = false
					end
					if MammutSell == true and MammutSelling == true then
						C_Timer.After(0.4, function() 
							C_MerchantFrame.SellAllJunkItems() 
							MammutSelling = false
						end)
					end
					C_Timer.After(0.8, function()	
						Mammutmounted = false
						MerchantFrameCloseButton:Click()
						Dismount()
						if State ~= "PAUSE" then
							if StateBeforMammut and StateBeforMammut == "SPOTFISHING" then
								State = StateBeforMammut
								SpotFishi()
							else
								State = "IDLE"
							end
						end
					end)
				end
			end
		end
		C_Timer.After(1, function() MammutInteract() end)
	else
		if StateBeforMammut and StateBeforMammut == "SPOTFISHING" then
			State = StateBeforMammut
			SpotFishi()
		else
			State = "IDLE"
		end
	end	
end

-- Fly pitch --
local function FlyPitch()
	local success, result = pcall(function()
		if State == "IDLE" or State == "MOVE" or State == "GOtoMAIL" or State == "CUSTOM_MOVE" then	
			local isGliding, canGlide, forwardSpeed = C_PlayerInfo.GetGlidingInfo()
			if x and isGliding and SteadyFly ~= true then
				local hx, hy, hz = TraceLine(px, py, (pz+0.05), x, y, z, hitFlags)
				if hx ~= 0 then -- not visible
					if pz < z then
						thz = z+50
					else
						thz = pz+50
					end
					local thpx, thpy, thpz = TraceLine(px, py, (pz+0.05), px, py, thz, hitFlags)
					if not thpx then
						thpz = thz
					end
					local thnx, thny, thnz = TraceLine(x, y, (z), x, y, thz, hitFlags)
					if not thnz then
						thnz = thz
					end
					Variant = TrLiPlayerToNode(px, py, pz, thpz, x, y, z, thnz)
					if Variant == "Var2" and State ~= "GOtoMAIL" then
						--print("Virt Skip Node")
						tarobject = nil
						fishpoolobj = nil
						NextPoint()
						return
					end
					Unstuck = true
					return
				elseif x then  -- visible
					local angle, calced_pitch = CalculateAngleAndPitchToPoint({x=px,y=py,z=pz},{x=x,y=y,z=z})
					SetAnglePitch(angle, calced_pitch)
				end
			end
		end
	end)
	if success then
	  
	else
	   print("FlyPi"..result)
	end
	C_Timer.After(0.03, FlyPitch)
end
FlyPitch() 

local function Routine()
	local success, result = pcall(function()
		RTime = 0.25
		if UnitIsDeadOrGhost("player")
		or State == "PAUSE"
		or State == "INN"
		or State == "HEARTSTONE"
		or State == "METAMORPH/EZ-MINE"
		or UnitCastingInfo("player") then
			return
		end
		if not x then
			--work = nodecheck()
			return
		end
		if NeedFlaskAndItemUse and not IsPlayerMoving() and not fishpool and State == "IDLE" then
			State = "ITEMUSE"
			work = Flask()
		end
		if State == "CAN_GATHER_START" 
		or State == "GATHER_START"
		and not UnitCastingInfo("player") then
			if ObjectDistance('player', tarobject) > 6 then
				State = "IDLE"
			end
			--work = nodecheck()
			return
		end
		if State == "IDLE" and x and tarobject then --and GLIDING == false then
			if SteadyFly == true and fishpoolobj and not IsFlying() and FastDistance(px, py, pz, x, y, z) < 2 then
				if moving then
					Eval('ToggleAutoRun()','')
					moving = nil
				end
				State = "FISHING"
			end
			local GLootdistance = ObjectDistance('player', tarobject)			
			if GLootdistance <= 6  and IsFlying() and (pz > z) then
				Eval('PitchDownStart()','')
				C_Timer.After(0.2, function() 
					Eval('PitchDownStop()','')
					SetPitch(0)
				end)
			end
			if GLootdistance <= 6  
			and not UnitCastingInfo("player") then
				if SteadyFly == true and GLootdistance <= 6  and IsFlying() and (pz > z) then
					Eval('PitchDownStart()','')
					Eval('ToggleAutoRun()','')
					--moving = true
					C_Timer.After(0.01, function() 
							Eval('PitchDownStop()','')
							Eval('ToggleAutoRun()','')
							--moving = nil
					end)
				end
				if SteadyFly == true and moving and not IsFlying() then
					Eval('ToggleAutoRun()','')
					moving = nil
				end
				
				if State ~= "CAN_GATHER_START" 
				and State ~= "OVERLOAD" 
				and State ~= "SPORE" 
				and State ~= "METAMORPH/EZ-MINE" 
				and not IsFlying() 
				and not IsPlayerMoving() 
				and not UnitCastingInfo("player")
				and not fishpoolobj
				and State ~= "PAUSE" 
				and (ObjectMovementFlag('player') == Flags.DESCENDING or ObjectMovementFlag('player') == Flags.NONE) then
					State = "CAN_GATHER_START"
				--end
					
				--if State == "CAN_GATHER_START" 
				--and not IsFlying() 
				--and not IsPlayerMoving() 
				--and not UnitCastingInfo("player")
				--and not fishpool then
					NodeID = ObjectId(tarobject)
					if OverHerb == true and CanOverloadHerb == true and CanDuplicateHerb ~= true then --and GLootdistance <= 5 then
						if NodeID == 414339
						or NodeID == 454079
						or NodeID == 454084
						or NodeID == 414338 
						or NodeID == 454008 
						or NodeID == 454053 
						or NodeID == 414336 
						or NodeID == 414335 
						or NodeID == 454066 
						or NodeID == 454069 
						or NodeID == 454074 
						or NodeID == 414337 then
							local HerbOverSpellCheck = C_Spell.GetSpellCooldown(423395)
							if HerbOverSpellCheck.startTime ~= 0 then
								Chiltime = nil
								State = "IDLE"
								return
							end
							State = "OVERLOAD"
							print("Overload Irradiated node")
							Eval('CastSpellByID(423395)',"")
							RTime = 4
							C_Timer.After(3, function() 
								timeToCheck = nil
								ObjectInteract(tarobject)
								if State ~= "PAUSE" then
									State = "IDLE"
									return
								end  
							end)
							return
						end
					end  
					if OverHerb == true and CanOverloadDFHerb == true and not UnitAffectingCombat("player") then --and GLootdistance <= 5 and not UnitAffectingCombat("player") then
						if NodeID == 398761
						or NodeID == 381210
						or NodeID == 375242
						or NodeID == 398759 
						or NodeID == 381196 
						or NodeID == 398760 
						or NodeID == 381205 
						or NodeID == 398762 then
							State = "OVERLOAD"
							if not UnitAffectingCombat("player") then
								print("Overload DF node")
								Eval('CastSpellByID(390392)',"")
							end
							C_Timer.After(2, function() 
								if State ~= "PAUSE" then
									State = "IDLE"
								end  
							end)
						end
					end 
					if OverHerb == true and Lambent == true and CanOverloadDFHerb == true and not UnitAffectingCombat("player") then --and GLootdistance <= 5 and not UnitAffectingCombat("player") then
						if NodeID == 390139 
						or NodeID == 390142 
						or NodeID == 390141 
						or NodeID == 390140 then
							State = "SPORE"	
							Spore()
							C_Timer.After(1, function() 
								if not UnitAffectingCombat("player") then
									if State ~= "PAUSE" then
										print("Overload DF node")
										Eval('CastSpellByID(390392)',"") 
									end
								end
							end)
							C_Timer.After(20, function() 
								if State ~= "PAUSE" then
									State = "IDLE"
								end 
							end)
						end
					end 
					if OverOrb == true and CanOverloadDFMining == true and not UnitAffectingCombat("player") then --and GLootdistance <= 5 and not UnitAffectingCombat("player") then
						if NodeID == 381518
						or NodeID == 375239
						or NodeID == 375238
						or NodeID == 381517 then
							State = "OVERLOAD"
							if not UnitAffectingCombat("player") then
								print("Overload DF node")
								Eval('CastSpellByID(388213)',"")
							end
							C_Timer.After(2, function() 
								if State ~= "PAUSE" then
									State = "IDLE"
								end  
							end)
						end
					end
					if CanDuplicateHerb == true and GetTime() <= (OverHerbExpTime-30) then --and GLootdistance <= 5 then
						if NodeID == 414319 or NodeID == 414331	or NodeID == 414336	or NodeID == 454055	or NodeID == 452973	or NodeID == 454006	
						or NodeID == 414344	or NodeID == 414341	or NodeID == 452977	or NodeID == 440162	or NodeID == 440163	or NodeID == 454050	
						or NodeID == 414329 or NodeID == 454007	or NodeID == 454010	or NodeID == 452978	or NodeID == 452971	or NodeID == 423366	
						or NodeID == 414339	or NodeID == 454051	or NodeID == 440189	or NodeID == 452976	or NodeID == 452979	or NodeID == 429646	
						or NodeID == 414324 or NodeID == 414326	or NodeID == 452975	or NodeID == 414316	or NodeID == 454009	or NodeID == 429641	
						or NodeID == 423363 or NodeID == 454008	or NodeID == 440164	or NodeID == 454545	or NodeID == 414321	
						or NodeID == 429639 or NodeID == 454053	or NodeID == 452972	or NodeID == 440167	or NodeID == 454054	
						or NodeID == 429644 then
							C_Timer.After(1.8, function() 
								if State ~= "PAUSE" then
									State = "IDLE"
								end           
							end)
							Eval('CastSpellByID(423395)',"") -- 439190
						end
					end   
					if CanDuplicateHerb == true and GetTime() <= OverHerbExpTime then --and GLootdistance <= 5 then
						if GetTime() >= (OverHerbExpTime-30) then
						   Eval('CastSpellByID(423395)',"")
						end
					end  
					if not LootFrame:IsVisible() and tarobject and ObjectLootable(tarobject)
					and not UnitCastingInfo("player")
					and not IsPlayerMoving() 
					and not IsFlying() 
					and (ObjectMovementFlag('player') == Flags.DESCENDING or ObjectMovementFlag('player') == Flags.NONE) then
						ObjectInteract(tarobject)
						return
						--table.insert(Blacklist, tarobject)
						--tarobject = nil
						--x,y,z = nil,nil,nil
						--print("\124cff3030FFI'm near the node, but don't loot it, because in a zerro loot mode.\124r")				
						
					end
				end                    
			end 
		end
		--if State == "IDLE" and not x then
			--work = nodecheck()
			--return
		--end
		if State == "IDLE" or State == "MOVE" then
			if not tarobject then
				--work = nodecheck()
				--return
			end		
		end
		if State == "IDLE" and x and xxp and x == xxp then
			--work = nodecheck()
		end		
		if State == "IDLE" and x and tarobject and fishpoolobj and (fishpoolobj == tarobject) then	
			if not foundpoollandplace then
				canland = nil
				xxp,yyp,zzp = PoolLandPlace(ObjectPosition(fishpoolobj))
				if xxp == 0 then --- Its ok let it
					tarobject = nil
					fishpoolobj = nil
					--C_Timer.After(0.1, Looting)
					return
				end
				x,y,z = xxp,yyp,zzp--+15 --TraceOverLandPlace(xxp,yyp,zzp)
			end
			if x and Lootdistance and Lootdistance <=2 and fishpoolobj and not IsPlayerMoving() and not IsSwimming() then
				local xf,yf,zf = ObjectPosition(fishpoolobj)
				local angle, calced_pitch = CalculateAngleAndPitchToPoint({x=px,y=py,z=pz},{x=xf,y=yf,z=zf})
				FaceDirection(angle, true)
				State = "FISHING"
				--MoveTo(x,y,z)
				--print("click")
			elseif x and Lootdistance and Lootdistance >= 2 and Lootdistance <= 6 and not UnitCastingInfo("player") and not UnitChannelInfo("player") and not IsPlayerMoving() and fishpoolobj then
				State = "MOVETO"
				Unstuck = true
				MoveTo(x,y,z)
				C_Timer.After(0.9, function() 
					if FastDistance(px, py, pz, x, y, z) <= 2 then
						if State ~= "PAUSE" then
							State = "FISHING"
						end							
					else
						if State ~= "PAUSE" then
							foundpoollandplace = nil
							State = "IDLE"
						end
					end
					Unstuck = false
				end)
			end
		elseif State == "IDLE" and x and tarobject and not fishpoolobj then
			if not foundlandplace then
				canland = nil
				xxp,yyp,zzp = NodeLandPlace(ObjectPosition(tarobject)) 
				if xxp == 0 then --- Its ok let it
					tarobject = nil
					--C_Timer.After(0.1, Looting)
					return
				end
				if SteadyFly == false then
					xxp,yyp,zzp = x,y,z
				end
				x,y,z = xxp,yyp,zzp+15 --TraceOverLandPlace(xxp,yyp,zzp)
			end
			
			if Lootdistance and Lootdistance <=6 and Human then
				work = CheckifHumanMove()
				--MoveTo(x,y,z)
				--print("click")
			end
		end
		
		if State == "IDLE" or State == "MOVE" or State == "GOtoMAIL" or State == "CUSTOM_MOVE" then	
			Vigor = C_UIWidgetManager.GetFillUpFramesWidgetVisualizationInfo(4460).numFullFrames
			local isGliding, canGlide, forwardSpeed = C_PlayerInfo.GetGlidingInfo()
			--if not x then
				--C_Timer.After(0.1, Looting)
				--return
			--end
			Targetdistance = FastDistance(px, py, pz, x, y, z)
			if State == "CUSTOM_MOVE" and Targetdistance and Targetdistance <= 5 then
				if moving then
					Eval('ToggleAutoRun()',"")
					moving = nil
				end
				if rechtssdreh then
					Eval('TurnRightStop()',"")
					rechtssdreh = nil
				end
				if linksdreh then
					Eval('TurnLeftStop()',"")
					linksdreh = nil
				end
				DirToReach = nil
				--C_Timer.After(0.1, Looting)
				return
			end
				
			if State == "IDLE" and tarobject and Targetdistance < 150 and Targetdistance > 20 then
				local Enemie, Elite = GetEnemiesAtPosition(tarobject)
				if (AvoidMobs and Enemie) or (AvoidElite and Elite) then
					tarobject = nil
					--x,y,z = nil,nil,nil	
					--C_Timer.After(0.1, Looting)
					return
				end
			end	
			if IsFlying() and State == "MOVE" then	
				tarobject = nil
				if x and xxp and x == xxp then
					xxp = nil
					x = nil
					--nodecheck()
					NextPoint()
					--return
				end
				if x and FastDistance(px, py, pz, x,y,z) < 30 then
					if LastPoint then
					end
					NextPoint()
					--C_Timer.After(0.1, Looting)
					--return
				end 
			end
			if x and SteadyFly == false and canGlide == true then
				--if not x then
					--C_Timer.After(0.1, Looting)
					--return
				--end
				Targetdistance = FastDistance(px, py, pz, x, y, z)
				if State == "IDLE" then
					Lootdistance = Targetdistance
				end
				local angle, calced_pitch = CalculateAngleAndPitchToPoint({x=px,y=py,z=pz},{x=x,y=y,z=z})
				if pz < z and isGliding and forwardSpeed < (MarshSpeed + 14) then                                 
					local isUsable, insufficientPower = C_Spell.IsSpellUsable(372610)
					local CDown = C_Spell.GetSpellCooldown(372610)
					if isUsable and CDown.startTime == 0 then
						local hx, hy, hz = TraceLine(px, py, (pz+0.5), px, py, (pz+10), hitFlags)
						if hx == 0 and not UnitCastingInfo("player") then 
							Eval('CastSpellByID(372610)',"")
						end
					end
				end
				if isGliding == true and Vigor > 0 and (forwardSpeed < (MarshSpeed + 14 )) and (forwardSpeed > 5) and Targetdistance > 70 then
					local isUsable, insufficientPower = C_Spell.IsSpellUsable(372608)
					local CDown = C_Spell.GetSpellCooldown(372608)
					if isUsable and CDown.startTime == 0 then
						Eval('CastSpellByID(372608)',"")
					end
				end  
				if isGliding == true and Vigor < 4 then
					local isUsable, insufficientPower = C_Spell.IsSpellUsable(425782)
					local CDown = C_Spell.GetSpellCooldown(425782)
					if isUsable and CDown.startTime == 0 then
						Eval('CastSpellByID(425782)',"")
					end
				end
				if canGlide == true and isGliding == false and State == "IDLE" 
				and (Targetdistance >= 4 and Targetdistance <= 20) and not UnitCastingInfo("player") and not UnitChannelInfo("player") and not IsPlayerMoving() then
					--print("Here is move")
					local hx, hy, hz = TraceLine(px, py, (pz+0.5), x, y, (z+0.5), hitFlags)
					if hx == 0 and z < (pz+2) then
						State = "MOVETO"
						Unstuck = true
						MoveTo(x,y,z)
						C_Timer.After(0.9, function() 
							if State ~= "PAUSE" then
								State = "IDLE"
							end
							Unstuck = false
							--C_Timer.After(0.1, Looting)
						end)                         
					end
				end
				if canGlide == true and isGliding == false and (State == "IDLE" or State == "MOVE" or State == "GOtoMAIL" or State == "CUSTOM_MOVE") and Vigor >= WVigor and Targetdistance >= 4 and not UnitCastingInfo("player") then
					local isUsable, insufficientPower = C_Spell.IsSpellUsable(372610)
					local CDown = C_Spell.GetSpellCooldown(372610)
					if isUsable and CDown.startTime == 0 then
						local hx, hy, hz = TraceLine(px, py, (pz+3), px, py, (pz+10), hitFlags)
						if hx == 0 and State ~= "JUMP" then 
							if Human then
								FaceDirection(angle, true)				
							else
								FaceDirection((angle % (2*math.pi)), false)
								SendMovementHeartbeat() 
							end
							if State ~= "JUMP" and State ~= "CHARGEVIGOR" then
								laststate = State
								State = "JUMP"
								if IsSwimming() then
									JumpOrAscendStart()
									C_Timer.After(0.5, function() 
										Eval('AscendStop()','')
										if State ~= "PAUSE" then
											State = laststate
										end
									end)
								else
									local CDown = C_Spell.GetSpellCooldown(372610)
									if CDown.startTime == 0 then
										Eval('CastSpellByID(372610)',"")
										C_Timer.After(1, function() 
											if State ~= "PAUSE" then
												State = laststate
											end
										end)
									end
								end
							end
						else
							awoid()
							--C_Timer.After(0.1, Looting)
							return
						end
					end
				end 
				if isGliding and Targetdistance <= 10 and forwardSpeed >= 30 and Vigor <= 4 then
					local isUsable, insufficientPower = C_Spell.IsSpellUsable(403092) --Aerial Halt
					local CDown = C_Spell.GetSpellCooldown(403092)
					if isUsable and CDown.startTime == 0 then
						Eval('CastSpellByID(403092)',"")  --print('Aerial Halt')
					end  
				end
				if  (State == "IDLE" or State == "GOtoMAIL") and x and xxp and tarobject then
					if FastDistance(px, py, pz,x,y,z) <= 100 then
						local hitx, hity, hitz
						if fishpoolobj then
							hitx, hity, hitz = TraceLine(px, py, pz, xxp,yyp,zzp+1, hitFlagsWithoutWat)
						else
							hitx, hity, hitz = TraceLine(px, py, pz, xxp,yyp,zzp+1, hitFlags)
						end
						if hitx == 0 then
							local angle, calced_pitch = CalculateAngleAndPitchToPoint({x=px,y=py,z=pz},{x=xxp,y=yyp,z=zzp})
							if calced_pitch < (-0.2) and calced_pitch > (-1.3) then
								--SetAnglePitch(angle, calced_pitch-0.05)
								x,y,z = xxp,yyp,zzp
								canland = true
								return
							end
						end
					end
					if FastDistance(px, py, pz,x,y,z) <= 15 then
						x,y,z = xxp,yyp,zzp
						canland = true
						return
					end
				end
				
				
			elseif SteadyFly == true then
				if not x or x == 0 then
					--C_Timer.After(0.1, Looting)
					return
				end
				Targetdistance = FastDistance(px, py, pz, x, y, z)
				if State == "IDLE" then
					Lootdistance = Targetdistance
				end
				local angle, calced_pitch = CalculateAngleAndPitchToPoint({x=px,y=py,z=pz},{x=x,y=y,z=z})
				if Targetdistance >= 3 and not moving then
					if (IsMounted() or (GetShapeshiftFormID() == 27)) and IsFlying() then
						Eval('ToggleAutoRun()','')
						moving = true
					end
				end
				if  (State == "IDLE" or State == "GOtoMAIL") and x and xxp and tarobject then
					if FastDistance(px, py, pz,x,y,z) <= 40 then
						local hitx, hity, hitz
						if fishpoolobj then
							hitx, hity, hitz = TraceLine(px, py, pz, xxp,yyp,zzp+1, hitFlagsWithoutWat)
						else
							hitx, hity, hitz = TraceLine(px, py, pz, xxp,yyp,zzp+1, hitFlags)
						end
						if hitx == 0 then
							local angle, calced_pitch = CalculateAngleAndPitchToPoint({x=px,y=py,z=pz},{x=xxp,y=yyp,z=zzp})
							if calced_pitch < (-0.25) then
								SetAnglePitch(angle, calced_pitch)
								x,y,z = xxp,yyp,zzp
								canland = true
								return
							end
						end
					end
					if FastDistance(px, py, pz,x,y,z) <= 15 then
						x,y,z = xxp,yyp,zzp
						canland = true
						return
					end
				end
				local hx, hy, hz = TraceLine(px, py, (pz+0.05), x, y, z, hitFlags)
				if hx ~= 0 then -- not visible
					if pz < z then
						thz = z+50
					else
						thz = pz+50
					end
					local thpx, thpy, thpz = TraceLine(px, py, (pz+0.05), px, py, thz, hitFlags)
					if thpz == 0 then
						thpz = thz
					end
					local thnx, thny, thnz = TraceLine(x, y, z, x, y, thz, hitFlags)
					if thnz == 0 then
						thnz = thz
					end
					Variant = TrLiPlayerToNode(px, py, pz, thpz, x, y, z, thnz)
					if Variant == "Var2" then
						--print("Virt Skip Node")
						table.insert(Blacklist, tarobject)
						tarobject = nil
						NextPoint()
						--C_Timer.After(0.1, Looting)
						return
					end
					Unstuck = true
					--C_Timer.After(0.1, Looting)
					return
				else  -- visible
					Unstuck = false
					if Targetdistance > 6 then
						if Human then
							FaceDirection(angle, true)
						else
							FaceDirection((angle % (2*math.pi)), false)
							SendMovementHeartbeat() 
						end
						if calced_pitch < (-1) then
							SetPitch(calced_pitch+(-0.1))
							SendMovementHeartbeat()
						elseif calced_pitch > (-0.5) or calced_pitch < 0.5 then
							if Targetdistance <= 15 then 
								SetPitch(calced_pitch+(-0.15))
								SendMovementHeartbeat()
							else
								SetPitch(calced_pitch)
								SendMovementHeartbeat()
							end
						end
					end
				end
			end
		end
	end)
	if success then
	  
	else
	   print("Routine"..result)
	end
	--Routine()
	C_Timer.After(RTime, Routine)
end
Routine()

SampleTracker = CreateFrame("Frame", nil, UIParent)
SampleTracker:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
SampleTracker:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
SampleTracker:RegisterEvent("UNIT_SPELLCAST_FAILED")
SampleTracker:RegisterEvent("UNIT_SPELLCAST_SENT")
SampleTracker:RegisterEvent("UNIT_SPELLCAST_START")
SampleTracker:RegisterEvent("UI_ERROR_MESSAGE")
SampleTracker:RegisterEvent("LOOT_OPENED")
SampleTracker:RegisterEvent("LOOT_CLOSED")
SampleTracker:RegisterEvent("UNIT_AURA")
SampleTracker:RegisterEvent("PLAYER_STARTED_MOVING")
SampleTracker:RegisterEvent("PLAYER_STOPPED_MOVING")
SampleTracker:RegisterEvent("PLAYER_IS_GLIDING_CHANGED")
SampleTracker:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_SHOW")
SampleTracker:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_HIDE")
SampleTracker:RegisterEvent("MAIL_SEND_SUCCESS")
SampleTracker:RegisterEvent("BAG_UPDATE_DELAYED")
SampleTracker:RegisterEvent("ZONE_CHANGED_INDOORS")
SampleTracker:SetScript("OnEvent", 
	function(self, event, ...)
        if UnitIsDeadOrGhost("player") then 
            return 
        end 
        if State == "PAUSE"  then
            return
        end
		
		if event == "UNIT_SPELLCAST_START" then
		skok = nil
			local arg1 = select(1, ...)
			local arg2 = select(2, ...)
			local arg3 = select(3, ...)
			local arg4 = select(4, ...)
            if arg1 == "player" then
                if arg3 == 441327
                or arg3 == 423341 
                or arg3 == 3365 
                or arg3 == 6478 then 
					caststart = GetTime()
                    if State ~= "GATHER_START" and State ~= "OVERLOAD_ORB" and State ~= "METAMORPH/EZ-MINE" then
                        State = "GATHER_START"
                    end
					Vigor = C_UIWidgetManager.GetFillUpFramesWidgetVisualizationInfo(4460).numFullFrames
					castendsoll = select(5,UnitCastingInfo("player"))
					--print(castendsoll)
					skok = ((select(5,UnitCastingInfo("player")))-(select(4,UnitCastingInfo("player"))))
					if (Vigor and Vigor < (WVigor + 1) and WVigor <= 6 and arg3 == 441327) or Stayonground then
						--print("Try vigor charge")
						if skok < 500 then
							ObjectInteract(tarobject)
						else
							C_Timer.After(((skok/1000)-0.5), function()
								if State ~= "PAUSE" and (ObjectMovementFlag('player') == Flags.DESCENDING or ObjectMovementFlag('player') == Flags.NONE) then
									ObjectInteract(tarobject)
								end								
							end)
						end
						return
					elseif Vigor and Vigor >= WVigor then
						--print("No vigor charge")
						if NodeID == 413895   
						or NodeID == 413886
						or NodeID == 413905 then
							EZ_Mine = true
						else
							EZ_Mine = false							
						end
						if EZ_Mine == false and State ~= "METAMORPH/EZ-MINE" and not UnitAffectingCombat("player") then
							if skok < 500 then
								--print("skok < 500")
								State = "JUMP"
								SetPitch(0)
								Eval('CastSpellByID(372610)', "")
								C_Timer.After(1, function() 
									if State ~= "PAUSE" then
										State = "IDLE"
										--nodecheck() 
									end
								end) 
							else
								--print("skok more 500")
								C_Timer.After(((skok/1000)-0.4), function()
									if State ~= "PAUSE" and not UnitAffectingCombat("player") then
										State = "JUMP"
										SetPitch(0)
										Eval('CastSpellByID(372610)', "")
										C_Timer.After(1, function() 
											if State ~= "PAUSE" then
												State = "IDLE"
												--nodecheck() 
											end
										end)
									end
								end)
							end
						end
					end
                end
			end
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			castend = GetTime()
			--print(castendist)
            local arg1 = select(1, ...)
			local arg3 = select(3, ...)
            if arg1 == "player" then
                if arg3 == 423394 then
					--BumTime = GetTime()+7.5
                    --State = "OVERLOAD_ORB"
					--print("SearchSplitt set to true")
                    SearchSplitt = true
					Speedy = nil
					State = "METAMORPH/EZ-MINE"
					C_Timer.After(1, function() 
						Metamorph()
					end)	
                    C_Timer.After(9.5, function() 
						if State ~= "PAUSE" then
							State = "IDLE"
						end
					end)
					C_Timer.After(11, function() 
						SearchSplitt = false
					end)
                end
                if arg3 == 423395 then
                    OverHerbExpTime = GetTime()+300
					C_Timer.After(10, function() 
						CanDuplicateHerb = true

					end)                    
                end
                if arg3 == 439190 then
					Stayonground = true
					C_Timer.After(10, function() 
						Stayonground = nil
					end)
                    CanDuplicateHerb = false
                    print("CanDuplicateHerb set to false")
                end
                if arg3 == 441327 
                or arg3 == 423341 
                or arg3 == 3365 
                or arg3 == 6478 then 
                end
				if arg3 == 8690 then
                    State = "HEARTSTONE"
					C_Timer.After(60, function()
						if State == "HEARTSTONE" then
							HSwalk()
						end
                    end)					
                end
				if arg3 == 83958 then
					C_Timer.After(1, function() 
						if State ~= "PAUSE" then
							GBInteract()
						end
                    end)					
                end
				if arg3 == 61447
				or arg3 == 61425 then
					C_Timer.After(0.5, function() 
						if State ~= "PAUSE" then
							Mammutmounted = true
							MammutInteract()
						end
                    end)					
                end
			end
		elseif event == "UNIT_SPELLCAST_FAILED"
			or event == "UNIT_SPELLCAST_FAILED_QUIET" then
			castfail = GetTime()
            local arg1 = select(1, ...)
            local arg3 = select(3, ...)
            if arg1 == "player" and State ~= "METAMORPH/EZ-MINE" then
                if arg3 == 441327 
                or arg3 == 423394 
                or arg3 == 423395 
                or arg3 == 423341 
                or arg3 == 3365 
                or arg3 == 6478 then 
                    State = "IDLE"
                    --nodecheck()
					--return
                end
			end
		elseif event == "UNIT_SPELLCAST_INTERRUPTED" then
			castfail = GetTime()
			if State ~= "OVERLOAD_ORB" and State ~= "METAMORPH/EZ-MINE" then
				local arg1 = select(1, ...)
				local arg3 = select(3, ...)
				if arg1 == "player" then
					if arg3 == 441327 
					or arg3 == 423394 
					or arg3 == 423395 
					or arg3 == 423341 
					or arg3 == 3365 
					or arg3 == 6478 then 
						if UnitAffectingCombat("player") then
							INTERRUPTED = INTERRUPTED + 1
						end                    
						if INTERRUPTED > 9 then
							print("Too many interrupts. Ignore node.")
							table.insert(Blacklist, ObjectGUID(tarobject))
							INTERRUPTED = 0
							State = "IDLE"
							--nodecheck()
							--return
						else
							C_Timer.After(0.1, function() 
								if State ~= "PAUSE" and (ObjectMovementFlag('player') == Flags.DESCENDING or ObjectMovementFlag('player') == Flags.NONE) then
									ObjectInteract(tarobject)
								end
							end)
						end
					end	
				end
				if State == "CAN_GATHER_START" or State == "GATHER_START" then
					State = "IDLE"
					--nodecheck()
					--return
				end
			end
		elseif event == "UNIT_SPELLCAST_CHANNEL_STOP" then			
		
		elseif event == "UI_ERROR_MESSAGE" then 
			local MSGID = select(1, ...)
			local MSG = select(2, ...)
            --DevTools_Dump({"UI_ERROR_MESSAGE",MSGID})
			if MSGID == 183 -- MSG == "There is no loot." 
            or MSGID == 591 then--MSG == "You can't loot that item now." then
				if State ~= "METAMORPH/EZ-MINE" then
					State = "IDLE"
					--nodecheck()
					--return
				end
			end	
			if MSGID == 664  then -- send Mail Stack full
			
			end
			if MSGID == 57 and AvoidMove == false then
                --[[AvoidMove = true
                local function awoid()
                    State = "AWOID"	
                    Eval('MoveBackwardStart()', "")			
                    C_Timer.After(0.1, function() 
                        Eval('MoveBackwardStop()', "")
                        Eval('StrafeRightStart()', "")	end)	
                    C_Timer.After(0.2, function() 
                        Eval('StrafeRightStop()', "")	
                        Eval('StrafeLeftStart()', "")	end)
                    C_Timer.After(0.4, function()	
                        Eval('StrafeLeftStop()', "")	 
                        State = "IDLE" end)	
                end
                C_Timer.After(0.5, function() 
                    AvoidMove = false
                end)]]--
            end
		elseif event == "LOOT_OPENED" then 
			lootisopen = GetTime()
		elseif event == "LOOT_CLOSED" then 
			lootisopen = nil
			Chiltime = nil
			Lastloot = GetTime()
			if State == "SPOTFISHING" then
				return
			end
			if State == "FISHING" and tarobject then
				return
			end
			tarobject = nil
            x, y, z = nil, nil, nil
			local Enemie, _ = GetEnemiesAtPosition("player") 
            if NodeID == 413895   
            or NodeID == 413886
            or NodeID == 413905 then
                EZ_Mine = true
            else
                EZ_Mine = false
            end
			if NodeID == 390137 
			or NodeID == 390138 
			or NodeID == 398747 
			or NodeID == 381515
			or NodeID == 375234 then	
				if OverOrb == true and CanOverloadDFMining == true and not UnitAffectingCombat("player") then	 --and Lootdistance and Lootdistance <= 5 and not UnitAffectingCombat("player") then	
					local Enemie, Elite
					AvoidMobs = true
					AvoidElite = true
					Mobrange = 20
					Enemie,Elite = GetEnemiesAtPosition("player")
					if Enemie == false
					and Elite == false	then
						State = "METAMORPH/EZ-MINE"		
						SearchSplitt = true
						print("Overload DF node")
						Eval('CastSpellByID(388213)','')
						if NodeID == 381515
						or NodeID == 375234 then
							T1,T2,T3,T4 = 3,4,12,20
						else
							T1,T2,T3,T4 = 3,12,20,60
						end
						C_Timer.After(T1, function()
							AvoidMobs = false
							AvoidElite = false
							if State ~= "PAUSE" then
								local active = GetShapeshiftFormID()
								if not IsMounted() and not UnitCastingInfo("player") then	
									if Druid then
										if not active then	
											Unlock('CastShapeshiftForm','3')  
										elseif active and active ~= 27 then
											if active ~= 4 then
												Unlock('CastShapeshiftForm','3')  
											end
											Unlock('JumpOrAscendStart','')
											--waterjump()
											C_Timer.After(3, function() Unlock('AscendStop','') end)
										end
									end
									if not Druid and not IsMounted() then
										if active and Class == "DRUID" then
											Unlock('CastShapeshiftForm',2)
										end
										chifmv = CheckifHumanMove()
										C_MountJournal.SummonByID(0)
									end	
								end 
							end						
						end)
						C_Timer.After(T2, function() 
							if State ~= "PAUSE" then
								Metamorph()	 
							end
						end)
						C_Timer.After(T3, function() 
							SearchSplitt = false
						end)
						C_Timer.After(T4, function() 
							if State == "METAMORPH/EZ-MINE" then
								State = "IDLE"
							end            
						end)
						return
					end
				end
			end
            if OverOrb == true and SearchSplitt == false and CanOverloadMining == true and EZ_Mine == true and not UnitAffectingCombat("player") then --and Lootdistance and Lootdistance <= 5 and Enemie == false then
                if State == "PAUSE" 
				or State == "FIGHT"
				or State == "HEARTSTONE"
				or State == "GUILDBANK"
				or State == "REPAIR/SELL"
				or State == "METAMORPH/EZ-MINE"
                or State == "DEAD" then
                    return
                end 
                timeToCheck = nil
                print("Overload EZ-Mine node")
                State = "OVERLOAD" 
                Eval('CastSpellByID(423394)','')
                C_Timer.After(2.6, function() 
					if State == "OVERLOAD" then
						State = "IDLE" 
					end
                end)               
            else
                if State == "PAUSE" 
				or State == "FIGHT"
				or State == "HEARTSTONE"
				or State == "GUILDBANK"
				or State == "REPAIR/SELL"
				or State == "SPORE"
				or State == "METAMORPH/EZ-MINE"
				or State == "JUMP"
                or State == "DEAD" then
                    return
                end 
                C_Timer.After(0.1, function()
                    if State ~= "PAUSE" then
						State = "IDLE"
						--nodecheck() 
						--return
					end
                end) 
                --print("Loot close")
                if Druid and GetShapeshiftFormID() ~= 27 then
                    Eval('CastShapeshiftForm(3)','')  
                end
				if not Druid and not IsMounted() then
					chifmv = CheckifHumanMove()
					C_MountJournal.SummonByID(0)
				end
            end
        elseif event == "UNIT_AURA" then
			local arg1 = select(1, ...)
			local arg2 = select(2, ...)
			local arg3 = select(3, ...)
            --DevTools_Dump({arg1,arg2,arg3})

        elseif event == "PLAYER_STOPPED_MOVING" then
			--print("Move end")
			--fireEvent("CastSucceeded", info)	
			--print("PLAYER_STOPPED_MOVING")
		elseif event == "PLAYER_STARTED_MOVING" then
			--print("PLAYER_STARTED_MOVING")
			--fireEvent("CastSucceeded", info)	
        elseif event == "PLAYER_IS_GLIDING_CHANGED" then
            GLIDING = select(1, ...)
			--print("PLAYER_IS_GLIDING_CHANGED "..arg)      
            --DevTools_Dump({"PLAYER_IS_GLIDING_CHANGED",GLIDING})
			if GLIDING == false then
				if (Lootdistance and Lootdistance <= 4)
				or State == "PAUSE"
				or State == "CHARGEVIGOR"
				or State == "GUILDBANK"
				or State == "REPAIR/SELL" 
				or State == "HEARTSTONE" then
					chifmv = CheckifHumanMove()
				end
			end
		elseif event == "PLAYER_INTERACTION_MANAGER_FRAME_SHOW" then
		--print("Frame show")
			local arg1 = select(1, ...)
			if arg1 == 10 then
				Stashing = true
				print("Deposit")
				LastDepTime = GetTime()
				DepositReagents()		
			end
			if arg1 == 17  and State == "GOtoMAIL" then
				State = "SENDMAIL"
				C_Timer.After(1, function()
					innbox = GetInboxNumItems()
					if innbox and innbox > 0 then
						print("open mail")
						OpenAllMail:Click()
						mailwait = (innbox * 1 + 2)
						C_Timer.After(mailwait, function() 
							print("ready to mailing")
							mailing = true -- mail to gutuar
							if State ~= "PAUSE" then
								MailFrameTab_OnClick(self, 2)
								SendMailtoSubj(0)	
							end
						end)
					else
						mailwait = 2
						C_Timer.After(mailwait, function() 
							print("ready to mailing")
							mailing = true -- mail to gutuar
							if State ~= "PAUSE" then
								MailFrameTab_OnClick(self, 2)
								SendMailtoSubj(0)	
							end
						end)
					end				
				end)
				--SendMail("gutuar", " ")
				--CloseMail() - Closes the mail window.
			end
		elseif event == "PLAYER_INTERACTION_MANAGER_FRAME_HIDE" then			
			local arg1 = select(1, ...)
			if arg1 == 10 then
				SaveSettings()
				Stashing = nil
				State = "IDLE"
			end
		elseif event == "MAIL_SEND_SUCCESS" then
		elseif event == "BAG_UPDATE_DELAYED" then
			LastDepTime = GetTime()
		elseif event == "ZONE_CHANGED_INDOORS" then
			if not IsIndoors("player") 
			and State == "HEARTSTONE" 
			and not UnitCastingInfo("player") then
				State = "IDLE"
				return
			end
			if IsIndoors("player") 
			and State == "HEARTSTONE" 
			and not UnitCastingInfo("player") then
				HSwalk()
				return
			end
		else
			--print(event, "unhandled")
		end
    end)
end)
