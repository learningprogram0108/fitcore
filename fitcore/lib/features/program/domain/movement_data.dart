// 動作知識庫 — 解剖聚焦、力學特徵、6 階段執行指南、核心提示詞
// 資料來源：Day 1-4 Movement Bible

import 'muscle_volume.dart';

class MovementPhase {
  const MovementPhase({required this.title, required this.content});
  final String title;
  final String content;
}

class MovementData {
  const MovementData({
    required this.id,
    required this.name,
    this.englishName = '',
    required this.anatomyFocus,
    required this.mechanics,
    required this.phases,
    required this.coreCues,
    required this.muscleWeights,
  });
  final String id;
  final String name;
  final String englishName; // 英文名稱（用於搜尋，不顯示在課表）
  final String anatomyFocus;
  final String mechanics;
  final List<MovementPhase> phases;
  final List<String> coreCues;
  final Map<MuscleGroup, double> muscleWeights;
}

class MovementLibrary {
  MovementLibrary._();

  static MovementData? find(String id) => _all[id];
  static Iterable<MovementData> get all => _all.values;

  static final Map<String, MovementData> _all = {
    // ─────────────────────── DAY 1 ───────────────────────
    'squat': const MovementData(
      id: 'squat',
      name: '槓鈴背蹲舉（高背槓）',
      englishName: 'High-Bar Back Squat',
      anatomyFocus: '**主動肌**：股四頭肌、臀大肌、大收肌\n**輔助肌**：腿後肌群、豎脊肌',
      mechanics: '槓鈴位於斜方肌上部，縮短了髖部阻力臂並拉長膝部阻力臂，重力線必須垂直穿過**足底中段（Mid-foot）**。',
      phases: [
        MovementPhase(
          title: '預備與創造張力階段 (Set-up & Tension Generation)',
          content: '雙手採取對稱且偏窄的握距抓緊槓鈴，雙肘向下推至槓下。主動向中線收攏並微聳斜方肌，建立一個「肌肉貨架」以安放槓。起槓後執行精準的「三步後退法」站定，雙腳約與肩同寬，腳尖自然朝外 15-20 度。\n\n張力創造：執行 Kelly Starrett 的中線穩定序列：骨盆維持中立，肋骨下壓，深吸一口氣進入腹部四周，創造極高的腹內壓 (IAP)。雙腳掌死死抓地，執行「雙腳旋入地面」，將股骨頭牢牢鎖進髖臼關節囊中，瞬間活化臀肌。',
        ),
        MovementPhase(
          title: '離心收縮階段 / 下放 (Eccentric Phase)',
          content: '髖關節與膝關節同步解鎖。想像你的軀幹重心是一部電梯，沿著垂直線直直下降，嚴禁單純將臀部往後推（會導致重心前移至腳尖）。膝蓋順利前移並精確追蹤腳尖方向，感受股四頭肌與臀大肌在其被拉長的軌跡上，承受越來越大的絕對機械張力。下放時間控制在穩定且抗阻的 2-3 秒。',
        ),
        MovementPhase(
          title: '最低點轉換期 / 減速與反轉 (Amortization Phase)',
          content: '當大腿上表面略低於膝關節（擊中深蹲平行線下方）時，身體達到最低點。此時神經系統最為敏感，主動肌內的肌梭 (Muscle Spindles) 被拉扯至極限，觸發防禦性的伸展反射 (Stretch Reflex)。此時必須死死咬住核心剛性，嚴禁骨盆與腰椎解耦產生「屁股眨眼 (Buttwink)」，不進行無謂的停頓，立刻將蓄積的彈性勢能準備轉化為向心動能。',
        ),
        MovementPhase(
          title: '向心收縮階段 / 推起 (Concentric Phase)',
          content: '足底三點（大拇趾球、小拇趾球、腳跟）同步對地板實施暴烈地向下蹬踏。當你推到大腿略高於平行線的「黏滯點 (Sticking Point)」時（此時幾何阻力臂達到最大值），上背肌群必須主動、死命地向後、向上頂推槓鈴，同時順勢將髖部向前驅動推進至槓鈴正下方，藉此調整解剖力臂，強勢穿過盲區。',
        ),
        MovementPhase(
          title: '鎖定與恢復階段 (Lockout & Reset)',
          content: '身體站直，雙膝、髖關節達到完全伸展。此時重力線完美穿過骨骼動力鏈（重力經骨盆直達足底中央）。嚴禁將雙膝過度反張 (Hyperextension) 借力。在頂端執行一次高質量的「清潔呼吸」排出 CO₂，隨後重新壓縮核心、創造外旋扭力，宣告下一次重複的開始。',
        ),
        MovementPhase(
          title: '核心提示詞 (Core Cues)',
          content: '「建立鋼鐵貨架」（收緊上背）\n「密封的可樂罐」（充盈腹內壓）\n「雙腳旋入地面」（創造外旋扭矩，膝蓋不內扣）\n「電梯垂直下降」（維持中足重心與直立軀幹）',
        ),
      ],
      coreCues: [
        '「建立鋼鐵貨架」— 收緊上背',
        '「密封的可樂罐」— 充盈腹內壓',
        '「雙腳旋入地面」— 膝蓋不內扣',
        '「電梯垂直下降」— 維持中足重心',
      ],
      muscleWeights: {
        MuscleGroup.quads: 1.0,
        MuscleGroup.posteriorChain: 1.0,
        MuscleGroup.core: 0.5,
      },
    ),

    'bulgarian': const MovementData(
      id: 'bulgarian',
      name: '保加利亞分腿蹲',
      englishName: 'Bulgarian Split Squat',
      anatomyFocus: '**主動肌**：股四頭肌、臀大肌\n**輔助肌**：臀中肌（額狀面主動穩定）、內收肌群',
      mechanics: '單側閉鎖鏈推力動作。消除了雙側大重量對脊椎的絕對**軸向壓縮**，強迫骨盆兩側的穩定肌群進行高強度**抗側屈、抗旋轉**。',
      phases: [
        MovementPhase(
          title: '預備與創造張力階段 (Set-up & Tension Generation)',
          content: '雙手各持合適噸位之啞鈴垂於身體兩側。背對臥推椅，往前跨出大約 2 至 3 個步幅。將後腳足背（或腳尖）平穩放置於後方長椅上。\n\n張力創造：前腳掌踩實地面，大拇趾球、小拇趾球與腳跟形成穩固的三角支點。收腹、挺胸、肋骨下壓。有意識地收緊雙側核心，特別是臀中肌與腰方肌，在動作發生前將骨盆鎖定在水平中立位，嚴禁高低骨盆或骨盆前傾。',
        ),
        MovementPhase(
          title: '離心收縮階段 / 下放 (Eccentric Phase)',
          content: '將全身體重的 80% 精確加載在前腳。前腳髖關節與膝關節同時解鎖，控制離心速度（2-3秒），引導整個身體向「斜後下方」坐落。後腳膝蓋僅作為平衡支點，順勢自然彎曲下沉。前腳股四頭肌與臀大肌此時產生極高張力的離心拉伸，前膝必須始終對齊前腳第二根腳趾。',
        ),
        MovementPhase(
          title: '最低點轉換期 / 減速與反轉 (Amortization Phase)',
          content: '當前大腿與地面平行、後膝接近觸地時達到轉換期。這是單側平衡挑戰最劇烈的時刻，身體的側向剪力達到最高。此時必須克服任何微小的左右晃動，前足三角如同釘子般死釘在地面，核心深層肌肉等長收縮，鎖定住骨盆幾何對稱，準備承接向心反轉。',
        ),
        MovementPhase(
          title: '向心收縮階段 / 推起 (Concentric Phase)',
          content: '前腳掌大拇趾球與中足全力「踩碎地面」，由前側股四頭肌的主動收縮與臀大肌的強烈伸髖共同驅動，將軀幹垂直推回。此時外側的臀中肌（Gluteus Medius）必須瘋狂發力，防止前膝在推起瞬間產生內收、內扣（膝外翻代償）的生物力學錯誤。',
        ),
        MovementPhase(
          title: '鎖定與恢復階段 (Lockout & Reset)',
          content: '前腿完全伸直，身體回到起始的單腳站立中立位。骨盆重回兩側對稱。此時在頂端重新校準重心，微調後腳與前腳的三角關係，重啟腹式呼吸並鎖定核心，切勿在不穩定的狀態下連續盲目執行。',
        ),
        MovementPhase(
          title: '核心提示詞 (Core Cues)',
          content: '「前腳三角釘死」（建立足底力學根基）\n「向斜後方下沉」（引導正確的髖鉸鏈與負重路徑）\n「用前腳踩碎地板」（專注單側四頭與臀肌驅動）\n「骨盆嚴禁傾斜」（強迫臀中肌與核心等長鎖定）',
        ),
      ],
      coreCues: [
        '「前腳三角釘死」— 建立足底力學根基',
        '「向斜後方下沉」— 正確髖鉸鏈路徑',
        '「用前腳踩碎地板」— 單側四頭與臀肌驅動',
        '「骨盆嚴禁傾斜」— 臀中肌等長鎖定',
      ],
      muscleWeights: {
        MuscleGroup.quads: 1.0,
        MuscleGroup.posteriorChain: 1.0,
      },
    ),

    'farmers_walk': const MovementData(
      id: 'farmers_walk',
      name: '農夫走路',
      englishName: "Farmer's Walk",
      anatomyFocus: '**主動肌**：核心肌群、斜方肌群、菱形肌、前臂屈肌群（握力）\n**輔助肌**：肱二頭肌（等長抗拉）',
      mechanics: '高噸位加載試圖拉塌肩胛骨、並在跨步時摧毀骨盆平衡。是極致的**等長收縮剛性**與**額狀面抗側屈**功能性特化訓練。',
      phases: [
        MovementPhase(
          title: '預備與創造張力階段 (Set-up & Tension Generation)',
          content: '兩側超重啞鈴或六角槓安放於雙腳正側邊，雙腳與髖同寬。執行一次堪稱教科書級別的髖鉸鏈（屈髖、屈膝、背部打直），雙手死死抓緊把手的幾何中心點。\n\n張力創造：在重量離地前，執行一次極高強度的腹內壓崩緊。雙肩主動向後收攏並向下沉，執行「把肩膀塞進褲子後口袋」的神經意象，活化闊背肌與前鋸肌，鎖定肩關節盂唇，建立對抗超重拉扯的鋼鐵貨架。',
        ),
        MovementPhase(
          title: '行走離心階段 / 動態步行力學 (Eccentric Phase)',
          content: '起槓階段：高質量伸髖將重量提離地面。行走離心階段：當你邁出第一步時，前腳跟擊向地面。此時，前側下肢與雙側核心必須承接身體因慣性向前、向下墜落的衝擊力。腰方肌（Quadratus Lumborum）與腹斜肌必須進行強烈的離心與等長對抗，去拉住被地心引力瘋狂向下扯的重物。',
        ),
        MovementPhase(
          title: '單腳過渡期 / 減速與反轉 (Amortization Phase)',
          content: '發生在單腳懸空、單腳著地的「單腳支撐過渡期」。此時，身體失去了雙側對稱支撐，超重載荷會極度試圖讓懸空側的骨盆下塌（產生側向剪力）。轉換期只有短短零點幾秒，著地側的臀中肌與核心對抗肌必須瞬間爆發剛性，將骨盆硬生生拉回水平，完成力的動態轉移。',
        ),
        MovementPhase(
          title: '向心推進階段 (Concentric Phase)',
          content: '後腳大拇趾球猛烈向後蹬地，推動身體持續向前推進。與此同時，你的上斜方肌、肩胛提肌與菱形肌正忍受著撕裂般的機械張力，實施高強度的向心/等長鎖定，死死頂住肩胛骨不被重物向下拉脫，這是建立厚實上背與斜方肌的黃金發力期。',
        ),
        MovementPhase(
          title: '鎖定與恢復階段 (Lockout & Reset)',
          content: '抵達終點線或在行進間的每一步頂端，脊椎與頭部始終維持中立延伸，嚴禁含胸駝背。由於大重量壓迫胸腔，此時無法執行深度腹式呼吸，必須在維持核心極高剛性的前提下，進行「高頻率、小口吸吐」的清潔呼吸，以排除高濃度 CO₂，維持神經系統不因缺氧而斷線。',
        ),
        MovementPhase(
          title: '核心提示詞 (Core Cues)',
          content: '「把肩膀塞進後口袋」（鎖定肩胛，防止關節拉脫）\n「頭頂拉向天花板」（脊椎中立延伸，嚴禁含胸）\n「鋼鐵鋁罐，微步前行」（維持核心動態剛性，步伐細碎且高頻）',
        ),
      ],
      coreCues: [
        '「把肩膀塞進後口袋」— 鎖定肩胛',
        '「頭頂拉向天花板」— 脊椎中立延伸',
        '「鋼鐵鋁罐，微步前行」— 核心動態剛性',
      ],
      muscleWeights: {
        MuscleGroup.core: 0.5,
        MuscleGroup.back: 0.5,
      },
    ),

    'calf_raise': const MovementData(
      id: 'calf_raise',
      name: '站姿提踵',
      englishName: 'Standing Calf Raise',
      anatomyFocus: '**主動肌**：小腿腓腸肌（雙關節肌特化）\n**輔助肌**：比目魚肌、足底韌帶與肌腱剛性',
      mechanics: '在膝關節完全伸直的幾何狀態下，小腿腓腸肌的起點與止點被拉至最長。此時施加重載，能觸發極強的**拉長狀態下增肌效應（Stretch-mediated hypertrophy）**。',
      phases: [
        MovementPhase(
          title: '預備與創造張力階段 (Set-up & Tension Generation)',
          content: '雙腳前腳掌（大拇趾球與前緣）穩固地踩在提踵機或深蹲架的踏板邊緣，後三分之二的腳掌與腳跟完全懸空。\n\n張力創造：雙膝維持在完全伸直但不過度反張的「鋼鐵直立狀態」。夾緊屁股，繃緊核心。此時將全身張力下傳至足底，大拇趾球踩實，調整踝關節力線，嚴禁出現內翻或外翻（腳踝向外或向內傾斜）。',
        ),
        MovementPhase(
          title: '離心收縮階段 / 下放 (Eccentric Phase)',
          content: '耗時整整 3 秒鐘，以極其緩慢且充滿控制力的速度，將腳跟緩緩降至踏板水平線以下。在此過程中，雙膝化為鋼鐵、絕不允許產生微幅彎曲。感受小腿後側的腓腸肌 (Gastrocnemius) 被地心引力強行扯開、拉長，累積巨大的離心機械張力。',
        ),
        MovementPhase(
          title: '最低點轉換期 / 強制暫停 (Amortization Phase)',
          content: '當腳跟降到最低點、小腿後側感受到極致拉扯感時，執行「死死停頓 1.5 到 2 秒」的強制暫停。\n\n生物力學目的：阿基里斯腱是人體最強大的彈性結構，下放會積蓄巨大的被動彈性動能。在此停頓 2 秒，能將阿基里斯腱的彈性勢能完全轉化為熱能消散，徹底消除回彈助力，確保接下來的向心階段是「純肌肉纖維」的硬實力發力。',
        ),
        MovementPhase(
          title: '向心收縮階段 / 推起 (Concentric Phase)',
          content: '大拇趾球與前腳掌爆發性向下「踩碎踏板」，將腳跟全力向天空推高，直到身體完全由足尖支撐。力的傳遞必須垂直向上，嚴禁重心內外偏移。小腿腓腸肌進行猛烈的向心縮短。',
        ),
        MovementPhase(
          title: '鎖定與恢復階段 (Lockout & Reset)',
          content: '在最高點達到關節鎖定，此時小腿肌肉群呈現極度擁擠的縮短狀態。在最高點死死停頓、瘋狂捏緊小腿 2 秒鐘（頂峰收縮）。保持呼吸，隨後重新校準足底平衡，準備進入下一次 3 秒的緩慢離心。',
        ),
        MovementPhase(
          title: '核心提示詞 (Core Cues)',
          content: '「雙膝化為鋼鐵」（膝蓋絕不彎曲，強迫腓腸肌吃重）\n「底部死停消除彈性」（停頓2秒，抹殺阿基里斯腱藉力）\n「大拇趾球踩碎地面」（力線對齊，嚴禁扭傷腳踝）\n「頂峰死捏2秒」（壓榨極致的向心收縮）',
        ),
      ],
      coreCues: [
        '「雙膝化為鋼鐵」— 強迫腓腸肌吃重',
        '「底部死停消除彈性」— 停頓2秒',
        '「大拇趾球踩碎地面」— 力線對齊',
        '「頂峰死捏2秒」— 極致向心收縮',
      ],
      muscleWeights: {},
    ),

    'copenhagen': const MovementData(
      id: 'copenhagen',
      name: '哥本哈根側平舉',
      englishName: 'Copenhagen Adduction',
      anatomyFocus: '**主動肌**：大腿內收肌群（大收肌、長收肌、股薄肌）、腹內/外斜肌、腰方肌',
      mechanics: '極致的**額狀面剪力對抗**動作。特化大腿內收肌群在拉長與縮短範圍下的絕對力量。**大收肌是深蹲底部的伸髖主力**，強化它能直接反哺深蹲與硬舉實力。',
      phases: [
        MovementPhase(
          title: '預備與創造張力階段 (Set-up & Tension Generation)',
          content: '在長椅旁呈標準側平板支撐姿勢，下方手肘垂直撐地，精確位於肩膀正下方，前臂與軀幹呈 90 度以創造穩固肩胛力矩。\n\n張力創造：將上方腿的膝蓋內側（初階）或足部內側邊緣（進階）平整且穩固地放置在長椅面上。下方腿自然伸直懸空。收腹、夾臀，肋骨下壓，讓身體在矢狀面/額狀面皆維持一條鋼板般的直線，內收肌預先繃緊。',
        ),
        MovementPhase(
          title: '離心收縮階段 / 下放 (Eccentric Phase)',
          content: '控制離心速度（2-3秒），由上方大腿內側的內收肌群（Adductors）實施抗阻伸展，引導骨盆與軀幹緩慢、垂直地朝地面降落。過程中，肩胛骨保持推地（前鋸肌等長收縮），嚴禁含胸或軀幹向地面旋轉（嚴禁轉動骨盆）。',
        ),
        MovementPhase(
          title: '最低點轉換期 / 減速與反轉 (Amortization Phase)',
          content: '當側骨盆外側輕輕觸碰地面（或極度接近地面）時，達到最低轉換點。此時上方內收肌群被拉扯至極長狀態。必須在現場保持絕對的身體剛性，嚴禁在觸地時整個人放鬆癱軟。核心兩側（腰方肌、腹斜肌）嚴密咬住張力，準備反轉。',
        ),
        MovementPhase(
          title: '向心收縮階段 / 推起 (Concentric Phase)',
          content: '上方大腿內側內收肌群爆發性向下「斬斷長椅」，利用巨大的反作用力，將骨盆與軀幹瘋狂頂向天花板。與此同時，著地側的腹內外斜肌與腰方肌強力向心縮短，協助側軀幹抬離地面，下方腿維持伸直懸空或屈髖靠向胸口。',
        ),
        MovementPhase(
          title: '鎖定與恢復階段 (Lockout & Reset)',
          content: '骨盆與軀幹推至最高點，此時身體從頭、肩、骨盆到上方大腿膝蓋呈一條完美的水平直線，維持鎖定 1 秒鐘。吐氣、重新校準撐地手肘的垂直受力線，再度拉緊核心，準備進入下一反覆。',
        ),
        MovementPhase(
          title: '核心提示詞 (Core Cues)',
          content: '「內側膝蓋斬斷長椅」（誘發內收肌極限發力）\n「骨盆頂向天花板」（確保完整的抬髖關節位移）\n「身體拒絕彎曲」（死守額狀面中線剛性，嚴禁駝背塌腰）',
        ),
      ],
      coreCues: [
        '「內側膝蓋斬斷長椅」— 內收肌極限發力',
        '「骨盆頂向天花板」— 完整髖關節位移',
        '「身體拒絕彎曲」— 額狀面中線剛性',
      ],
      muscleWeights: {
        MuscleGroup.core: 0.5,
      },
    ),

    // ─────────────────────── DAY 2 ───────────────────────
    'bench': const MovementData(
      id: 'bench',
      name: '槓鈴臥推',
      englishName: 'Barbell Bench Press',
      anatomyFocus: '**主動肌**：胸大肌、肩部前三角肌、肱三頭肌（鎖定階段）\n**輔助肌**：背闊肌（等長穩定）',
      mechanics: '水平推力動作。透過**拱背**縮短阻力臂，並利用**腿部驅動（Leg Drive）**將下肢力量經由剛性軀幹傳導至上肢發力底座。',
      phases: [
        MovementPhase(
          title: '預備與創造張力階段 (Set-up & Tension Generation)',
          content: '躺臥於椅面上，雙眼精確位於槓鈴正下方。雙手採取約 1.5 倍肩寬的對稱握距，槓鈴穩固安放在掌心低處（接近前臂骨頭軸線），指關節死死握緊。雙腳向後收緊並全腳掌踩實地面。\n\n張力創造：啟動 Kelly Starrett 肩關節鎖定序列：將肩胛骨強力後收並向下沉（像要把肩胛骨塞進褲子後口袋），建立一個無比堅固的上背底座。雙腳踩地實施向上、向後的推力（Leg Drive），將骨盆與脊椎推成一個安全、剛性的拱形。在取槓前，深吸氣創造腹內壓，雙手實施「將槓鈴折彎 (Bend the bar)」的外旋力矩，瞬間活化背闊肌。',
        ),
        MovementPhase(
          title: '離心收縮階段 / 下放 (Eccentric Phase)',
          content: '雙肘解鎖，控制下放速度（耗時 2-3 秒）。槓鈴的運動軌跡不是垂直向下，而是一條向腳側微幅傾斜的斜向弧線。雙肘保持在槓鈴正下方，與軀幹自然呈 45-60 度夾角（嚴禁雙肘 90 度外展，這會導致肩峰下空間變窄進而產生夾擠）。胸大肌與前三角肌在其拉長範圍內承受巨大的離心機械張力。',
        ),
        MovementPhase(
          title: '最低點轉換期 / 減速與反轉 (Amortization Phase)',
          content: '槓鈴輕柔、精確地觸碰在乳頭至胸骨底部之間的微小盲區（擊中張力甜蜜點）。此時神經中樞張力達到最高，胸大肌的腱梭與肌梭被拉扯至極限。必須在此維持「輕柔暫停 (Soft Pause)」1 秒，死死咬住上背部的等長收縮，嚴禁含胸塌陷或利用胸腔彈動（Bounce）借力，準備將重力勢能反轉。',
        ),
        MovementPhase(
          title: '向心收縮階段 / 推起 (Concentric Phase)',
          content: '雙腳掌猛烈向地面發動 Leg Drive，將力量經由核心傳導至斜方肌，上背部死命頂住椅墊。雙手全力向上、向臉部方向斜向推起槓鈴。當槓鈴離胸約 5-10 公分遭遇「黏滯點 (Sticking Point)」時，主動外展雙肘並微幅內旋肩膀，強行優化胸大肌對肱骨的拉力線，撐過這段阻力臂最大的幾何盲區。',
        ),
        MovementPhase(
          title: '鎖定與恢復階段 (Lockout & Reset)',
          content: '槓鈴推至頂端，雙肘完全伸直鎖定，槓鈴重力線垂直穿過肩關節。此時由骨骼結構承重，嚴禁肩膀往前衝（骨盆與肩胛解耦）。在此執行清潔呼吸，重新收緊肩胛骨，為下一次反覆校準根基。',
        ),
        MovementPhase(
          title: '核心提示詞 (Core Cues)',
          content: '「肩胛塞進後口袋」（建立推起底座）\n「將槓鈴折彎」（外旋鎖定肩關節，啟動背闊肌）\n「用腳把地板往前推」（啟動下肢驅動傳導）\n「推碎椅墊，肘部相對」（穿過黏滯點與末端鎖定）',
        ),
      ],
      coreCues: [
        '「肩胛塞進後口袋」— 建立推起底座',
        '「將槓鈴折彎」— 外旋鎖定肩關節',
        '「用腳把地板往前推」— 啟動下肢驅動',
        '「推碎椅墊，肘部相對」— 穿過黏滯點',
      ],
      muscleWeights: {
        MuscleGroup.chest: 1.0,
        MuscleGroup.frontDelt: 0.5,
        MuscleGroup.triceps: 0.5,
      },
    ),

    'pullup': const MovementData(
      id: 'pullup',
      name: '正手寬握引體向上',
      englishName: 'Pronated Wide-Grip Pull-Up',
      anatomyFocus: '**主動肌**：背闊肌、大圓肌、後三角肌、中下斜方肌（肩胛收縮）\n**輔助肌**：肱二頭肌',
      mechanics: '垂直拉力的**閉鎖式動力鏈（CKC）**王牌動作。藉由正手寬握限制肘關節屈曲，大幅減少手臂代償，迫使**背闊肌外側**與上背肌群承載身體全重，特化背部寬度。',
      phases: [
        MovementPhase(
          title: '預備與創造張力階段 (Set-up & Tension Generation)',
          content: '雙手採取正手（掌心朝前）懸掛於單槓上，握距約為肩寬的 1.2 至 1.5 倍。雙腳離地，膝蓋可微彎並腳踝交叉，或保持雙腿併攏伸直。\n\n張力創造：從「死懸掛 (Dead Hang)」過渡到「主動懸掛 (Active Hang)」。雙肩主動向下沉（肩胛下沉），將耳朵與肩膀之間的距離拉開，活化前鋸肌與中下斜方肌。腹肌與臀肌同步收緊，使整個軀幹化為一塊毫無張力洩漏的「剛性鋼板」，嚴禁身體鬆垮晃動。',
        ),
        MovementPhase(
          title: '離心收縮階段 / 下放 (Eccentric Phase)',
          content: '從頂端控制身體以 2-3 秒的速度緩慢下放。感受兩側背闊肌與大圓肌在外側被身體重量強行拉長、撕裂的極限機械張力。下放時軀幹維持剛性，切勿任由地心引力將身體直接摔落，這會導致肩關節韌帶急性拉傷。',
        ),
        MovementPhase(
          title: '最低點轉換期 / 減速與反轉 (Amortization Phase)',
          content: '身體降至最底部的主動懸掛位置。此時背闊肌被拉至最長，肌梭觸發強烈的伸展反射。在此不進行過長停頓，嚴禁完全放鬆卸力變成死懸掛（這會導致神經斷線與代償）。咬住背部張力，預備反轉。',
        ),
        MovementPhase(
          title: '向心收縮階段 / 拉起 (Concentric Phase)',
          content: '大腦引導神經意象，嚴禁用意志力去「用手拉單槓」（這會導致手臂先疲勞）。想像你的雙手只是勾子，全力將雙肘向後、向下撞擊肋骨兩側。軀幹微幅後仰，保持挺胸，引導胸骨上緣向單槓頂端撞擊。當拉到中段黏滯點時，持續下壓肩胛骨，強迫背闊肌的外側纖維與大圓肌完全收縮。',
        ),
        MovementPhase(
          title: '鎖定與恢復階段 (Lockout & Reset)',
          content: '下巴清晰越過單槓，或胸骨上緣輕觸單槓。此時肩胛骨達到最大幅度的下沉與後收（Retraction）。在頂端頂峰收縮鎖定 0.5 秒。保持呼氣，維持骨盆與中線絕對穩定，隨後平穩進入下一次控制離心。',
        ),
        MovementPhase(
          title: '核心提示詞 (Core Cues)',
          content: '「雙肩遠離耳朵」（建立主動懸掛，啟動上背）\n「軀幹化為鋼板」（核心繃緊，嚴禁身體晃動）\n「手肘撞擊肋骨」（用背主導，摒除手臂代償）\n「胸骨頂向單槓」（確保完整的背肌向心收縮軌跡）',
        ),
      ],
      coreCues: [
        '「雙肩遠離耳朵」— 建立主動懸掛',
        '「軀幹化為鋼板」— 核心繃緊',
        '「手肘撞擊肋骨」— 用背主導',
        '「胸骨頂向單槓」— 完整背肌收縮',
      ],
      muscleWeights: {
        MuscleGroup.back: 1.0,
        MuscleGroup.biceps: 0.5,
        MuscleGroup.sideDelt: 0.5,
      },
    ),

    'ohp': const MovementData(
      id: 'ohp',
      name: '槓鈴肩推',
      englishName: 'Overhead Press',
      anatomyFocus: '**主動肌**：三角肌前/中束、肱三頭肌（鎖定階段）\n**輔助肌**：上斜方肌（末端鎖定）、核心肌群（中軸剛性等長收縮）',
      mechanics: '大重量站姿垂直推動作。根據 Mark Rippetoe 的幾何力學，槓鈴重力線在動作起點與終點都必須與**中足（Mid-foot）**完美對齊。',
      phases: [
        MovementPhase(
          title: '預備與創造張力階段 (Set-up & Tension Generation)',
          content: '槓鈴架設在接近胸骨上緣高度。雙手以略寬於肩的握距抓槓，前臂旋前踩入槓下，使槓鈴穩固坐落在掌心低處。雙腳與髖同寬站定。\n\n張力創造：將雙肘向前、向上推，使前臂在正面幾何上與地面保持絕對垂直，槓鈴架設在三角肌前束與鎖骨創造的「前貨架」上。執行中線穩定：死死夾緊臀大肌以鎖定骨盆（防止凹下背代償），大腿前側收緊，深吸氣進入腹部，將整個中軀幹壓縮成鋼鐵鋁罐。',
        ),
        MovementPhase(
          title: '離心收縮階段 / 下放 (Eccentric Phase)',
          content: '控制槓鈴沿著貼近面部的垂直線緩慢下降。當槓鈴經過額頭時，面部微幅向後微仰（藏頭），給槓鈴創造通過的幾何空間。雙肘持續維持在槓鈴正下方（維持前臂垂直），直到槓鈴安全、抗阻地回到鎖骨前貨架。',
        ),
        MovementPhase(
          title: '最低點轉換期 / 減速與反轉 (Amortization Phase)',
          content: '當槓鈴輕觸大圓肌/胸骨上緣前貨架的瞬間，達到轉換期。這是脊椎剪力最危險的時刻。你必須將腹內壓撐到極限，臀肌與股四頭肌等長收縮鎖死，嚴禁下肢關節微彎借力（這會變成 Push Press 舞弊）。咬住全身剛性，立刻發動反轉。',
        ),
        MovementPhase(
          title: '向心收縮階段 / 推起 (Concentric Phase)',
          content: '足底三點死踩地面，三角肌與三頭肌爆發性發力，將槓鈴貼著面部筆直推向天空。當槓鈴經過面部時，頭部稍微後仰；一旦槓鈴越過額頭高度，立即將頭部「推進（Drive）」手臂創造的視窗中。這能讓槓鈴重力線在半空中重回中足正上方，順利穿過垂直力矩最大的黏滯點。',
        ),
        MovementPhase(
          title: '鎖定與恢復階段 (Lockout & Reset)',
          content: '槓鈴在頭頂最高點鎖定。雙肘完全伸直，上斜方肌實施強烈的「向上聳肩 (Active Shrug)」，將肩關節盂唇完全鎖死。此時槓鈴、肩、髖、足底中段呈完美的一線幾何結構。在頂端吐氣，並執行一次快速清潔呼吸，重新繃緊屁股，校準中線迎戰下一把。',
        ),
        MovementPhase(
          title: '核心提示詞 (Core Cues)',
          content: '「大腿收緊，屁股夾死」（鎖定下肢與骨盆，防止凹下背）\n「前臂垂直，手肘向前」（建立完美的推舉力學力臂）\n「越過額頭，藏頭進窗」（微調幾何重心，突破黏滯點）\n「向天花板主動聳肩」（頂端骨骼力學鎖定，保護肩盂唇）',
        ),
      ],
      coreCues: [
        '「大腿收緊，屁股夾死」— 防止凹下背',
        '「前臂垂直，手肘向前」— 完美力學力臂',
        '「越過額頭，藏頭進窗」— 突破黏滯點',
        '「向天花板主動聳肩」— 頂端骨骼鎖定',
      ],
      muscleWeights: {
        MuscleGroup.frontDelt: 1.0,
        MuscleGroup.triceps: 0.5,
        MuscleGroup.sideDelt: 0.5,
      },
    ),

    'face_pull': const MovementData(
      id: 'face_pull',
      name: '滑輪面拉',
      englishName: 'Cable Face Pull',
      anatomyFocus: '**主動肌**：後三角肌、中下斜方肌、菱形肌\n**特化**：旋轉肌群（岡下肌/小圓肌）外旋訓練',
      mechanics: '兼具**水平拉**與**動態外旋（External Rotation）**的功能性動作。專治長期的含胸駝背，為大重量臥推與肩推建立極致的肩胛後側平衡。',
      phases: [
        MovementPhase(
          title: '預備與創造張力階段 (Set-up & Tension Generation)',
          content: '將滑輪高度調整至與雙眼或上胸對齊。使用繩索把手，採取「大拇指朝後（thumbs-back）」的抓握方式（這能預先誘導肩關節外旋）。雙腳採取前後站姿（弓步）或與肩同寬站姿。\n\n張力創造：向後退一步使配重片懸空。膝蓋微彎，收腹挺胸，肋骨下壓。雙肩主動下沉，嚴禁聳肩。前臂與滑輪纜繩保持在同一條水平拉力線上，後側後三角肌預先咬住張力。',
        ),
        MovementPhase(
          title: '離心收縮階段 / 下放 (Eccentric Phase)',
          content: '控制滑輪纜繩的拉力，耗時 2-3 秒控制離心。允許雙手被緩慢拉回靠近機器方向，此時肩胛骨自然進行微幅的前引（Protraction），感受後三角肌、菱形肌與中斜方肌在拉長狀態下承受持續性的高密度機械張力。',
        ),
        MovementPhase(
          title: '最低點轉換期 / 減速與反轉 (Amortization Phase)',
          content: '當手臂完全伸直、纜繩拉力達到最長延伸點時，達到過渡期。此時中軸核心必須死死頂住，防止身體被滑輪力道向前拽動。維持頸椎中立，嚴禁脖子往前探（龜頸代償），咬住背部張力，準備反轉。',
        ),
        MovementPhase(
          title: '向心收縮階段 / 拉回 (Concentric Phase)',
          content: '後三角肌與肩胛肌群全面性爆發收縮。發力意象為「用雙肘將繩索撕成兩半」。一邊將手肘向身體兩側打寬、向後拉動，一邊將雙手把手拉向雙耳與眼睛兩側。在向心後半段，全力執行肩關節外旋（手腕高度必須超越手肘高度），逼迫岡下肌與小圓肌瘋狂參與。',
        ),
        MovementPhase(
          title: '鎖定與恢復階段 (Lockout & Reset)',
          content: '在動作終點，雙手把手精確位於雙耳兩側，整個上背部呈現一個完美的「W」字幾何造型。此時肩胛骨達到極限的後收（夾背）與下沉。在終點線強制死鎖、擠壓 1-2 秒鐘。穩定呼吸，隨後平穩放回。',
        ),
        MovementPhase(
          title: '核心提示詞 (Core Cues)',
          content: '「大拇指朝後抓握」（預導外旋軌跡）\n「脖子打直，嚴禁龜頸」（維持頸椎安全位）\n「雙肘打寬，撕裂繩索」（主導後三角與中背招募）\n「手腕高於手肘，極限夾背2秒」（強迫旋轉肌群外旋與頂峰收縮）',
        ),
      ],
      coreCues: [
        '「大拇指朝後抓握」— 預導外旋軌跡',
        '「脖子打直，嚴禁龜頸」— 頸椎安全位',
        '「雙肘打寬，撕裂繩索」— 後三角與中背',
        '「手腕高於手肘，夾背2秒」— 外旋頂峰收縮',
      ],
      muscleWeights: {
        MuscleGroup.sideDelt: 1.0,
        MuscleGroup.back: 0.5,
      },
    ),

    'triceps_pushdown': const MovementData(
      id: 'triceps_pushdown',
      name: '滑輪三頭下壓',
      englishName: 'Cable Triceps Pushdown',
      anatomyFocus: '**主動肌**：肱三頭肌（長頭、外側頭、內側頭全面特化）\n**輔助肌**：肘肌',
      mechanics: '單關節、**肘主導（Elbow Extension）**的肱三頭肌孤立動作。透過繩索的持續恆定張力，在整個關節角度範圍內施加均勻的機械張力。底部**頂峰收縮**可壓榨極致的代謝壓力，為臥推與肩推的鎖定力量奠定基礎。',
      phases: [
        MovementPhase(
          title: '預備與創造張力階段 (Set-up & Tension Generation)',
          content: '將滑輪高度設定在頭頂或略高於頭頂的位置，使用繩索把手（Rope）。雙腳與肩同寬站定，軀幹微幅前傾以建立穩固的支點。\n\n張力創造：雙肘緊貼身體兩側，死死鎖定在肋骨側面，嚴禁外飄。前臂與地面平行或略低，讓三頭肌長頭在頂端預先承受拉長狀態下的機械張力。收腹挺胸，核心剛性鎖死，準備進入向心發力。',
        ),
        MovementPhase(
          title: '離心收縮階段 / 回放 (Eccentric Phase)',
          content: '控制繩索的回彈力，耗時整整 2-3 秒讓前臂緩慢向上回放至起始位置。在此過程中，三頭肌進行高密度的離心拉長，嚴禁讓上臂隨著重量離開軀幹側面（肩關節代償）。感受三頭肌長頭在被強行拉長的軌跡上，承受持續且均勻的機械張力。',
        ),
        MovementPhase(
          title: '最低點轉換期 / 拉長反轉 (Amortization Phase)',
          content: '當前臂回到與地面平行或略高於水平的位置，三頭肌長頭（跨越肩關節的雙關節肌）被充分預拉長至最大伸展點。此時死死咬住上臂鎖定在肋骨側面的位置，嚴禁肩關節產生任何屈曲代償。咬住張力，順應伸展反射，立刻反轉發動向心。',
        ),
        MovementPhase(
          title: '向心收縮階段 / 下壓 (Concentric Phase)',
          content: '三頭肌爆發性向心收縮，前臂猛烈向下推壓，將繩索兩端向兩側斜向分開拉至最低點。發力意象為「用手肘把地板往下捅穿」。在整個下壓過程中，上臂如同焊接在肋骨側面，只有前臂移動，確保三頭肌獲得最純粹的孤立刺激。',
        ),
        MovementPhase(
          title: '鎖定與恢復階段 (Lockout & Reset)',
          content: '在最低點（肘關節接近完全伸直），繩索兩端向兩側分開，三頭肌達到極限縮短狀態。強制執行「頂峰收縮死鎖 1-2 秒」，瘋狂擠壓三頭肌，製造極大化的代謝壓力與肌泵感。穩定呼氣，重新校準肘部位置，隨後平穩進入下一次控制離心。',
        ),
        MovementPhase(
          title: '核心提示詞 (Core Cues)',
          content: '「上臂死貼肋骨，嚴禁外飄」（分離肩關節代償，確保三頭肌孤立發力）\n「用肘往下捅穿地板」（三頭肌爆發性向心收縮）\n「繩子向兩側撕開，底部擠壓2秒」（頂峰收縮壓榨極致代謝張力）\n「緩慢回放，對抗繩索」（離心拉長肌肥大訊號）',
        ),
      ],
      coreCues: [
        '「上臂死貼肋骨，嚴禁外飄」— 三頭肌孤立',
        '「用肘往下捅穿地板」— 爆發性向心',
        '「繩子向兩側撕開，底部擠壓2秒」— 頂峰收縮',
        '「緩慢回放，對抗繩索」— 離心肌肥大',
      ],
      muscleWeights: {
        MuscleGroup.triceps: 1.0,
      },
    ),

    // ─────────────────────── DAY 3 ───────────────────────
    'hex_deadlift': const MovementData(
      id: 'hex_deadlift',
      name: '六角槓硬舉',
      englishName: 'Hex Bar Deadlift',
      anatomyFocus: '**主動肌**：股四頭肌、臀大肌、背部豎脊肌\n**輔助肌**：腿後肌群、核心肌群',
      mechanics: '結合深蹲與硬舉幾何的複合鉸鏈動作。重力線直接穿過中足與身體中心，相比傳統直槓硬舉，大幅縮短了腰椎的**剪力力臂（Shear Moment Arm）**，允許中樞神經以最高功率驅動下肢伸髖。',
      phases: [
        MovementPhase(
          title: '預備與創造張力階段 (Set-up & Tension Generation)',
          content: '步入六角槓中心，雙腳約與髖同寬站定。屈髖、屈膝下蹲，雙手精確抓緊兩側把手的幾何中點（防止起槓時槓體前後傾斜）。\n\n張力創造：執行 Pack down 鎖定：肩胛骨主動下沉、雙肘內夾，想像雙手試圖「把把手捏碎」，這能瞬間拉緊配重線並啟動背闊肌。深吸氣執行 360 度核心擴張建立腹內壓（IAP）。雙腳掌踩實地面，向外施加「試圖把地面撕成兩半」的側向扭矩，將髖部完全鎖定。',
        ),
        MovementPhase(
          title: '離心收縮階段 / 下放 (Eccentric Phase)',
          content: '鎖定頂端解鎖髖關節，主動將臀部向斜後方推動（髖鉸鏈）。槓體沿著絕對垂直的重力線控制下放（耗時 2 秒）。當槓鈴過膝後，膝關節順勢自然彎曲。此時，股四頭肌、臀大肌與豎脊肌進行高度抗阻的離心收縮，軀幹嚴禁鬆垮、含胸，背部打直如同一塊鋼板。',
        ),
        MovementPhase(
          title: '最低點轉換期 / 減速與反轉 (Amortization Phase)',
          content: '當槓片輕觸地面（或在離地 1 公分處，執行 Touch-and-Go）的瞬間達到轉換期。此時腰椎承受軸向載荷最高。你必須死死咬住腹內壓，保持骨盆與脊椎中立位解耦。不進行全身卸力、不容許張力產生一絲一毫的洩漏，神經系統瞬間將減速力道反轉為向心起爆力。',
        ),
        MovementPhase(
          title: '向心收縮階段 / 起槓 (Concentric Phase)',
          content: '神經系統全面起爆。發力意象絕非「用腰把重量拉起來」，而是「用雙腿死命蹬碎地面」（Leg Drive）。股四頭肌首先發力完成起槓，當槓鈴越過小腿中段後，臀大肌與腿後肌群強烈收縮接管動作，將骨盆強勢向前推動。透過黏滯點時，維持背部僵直，將地面反作用力完整傳導至上肢。',
        ),
        MovementPhase(
          title: '鎖定與恢復階段 (Lockout & Reset)',
          content: '身體完全站直，雙膝、雙髖完全伸直。臀大肌強力向心收縮鎖死。嚴禁為了追求鎖定而將腰椎向後過度拱背（Hyperextension），這會產生致命的椎間盤擠壓。在頂端挺胸，執行一次清潔呼吸，重新鎖定肩胛貨架，迎接下一次反覆。',
        ),
        MovementPhase(
          title: '核心提示詞 (Core Cues)',
          content: '「把把手捏碎，拉緊拉力線」（預先收緊上背與手臂張力）\n「用雙腿踩穿地板」（摒除下背發力，改由下肢驅動起槓）\n「撕裂地面，臀部前推」（過膝後強烈伸髖鎖定）',
        ),
      ],
      coreCues: [
        '「把把手捏碎，拉緊拉力線」— 收緊上背張力',
        '「用雙腿踩穿地板」— 下肢驅動起槓',
        '「撕裂地面，臀部前推」— 過膝強烈伸髖',
      ],
      muscleWeights: {
        MuscleGroup.quads: 1.0,
        MuscleGroup.posteriorChain: 1.0,
        MuscleGroup.back: 0.5,
        MuscleGroup.core: 0.5,
      },
    ),

    'zercher': const MovementData(
      id: 'zercher',
      name: '澤奇深蹲',
      englishName: 'Zercher Squat',
      anatomyFocus: '**主動肌**：股四頭肌、核心肌群（抗屈曲特化）、上背肌群（斜方肌/菱形肌）\n**輔助肌**：臀大肌、肱二頭肌（等長抗拉）',
      mechanics: '極致的**前載荷（Front-loaded）**深蹲。槓鈴架設於雙肘肘彎，重力極度試圖將胸椎與腰椎拉向「屈曲（駝背）」。這迫使整個後側豎脊肌與前側核心產生**無與倫比的等長剛性收縮**。',
      phases: [
        MovementPhase(
          title: '預備與創造張力階段 (Set-up & Tension Generation)',
          content: '槓鈴架設在接近腹部高度。雙肘完全彎曲，將槓鈴鎖在雙肘肘彎中。雙手可以交疊握拳，將肘彎死死貼緊軀幹肋骨兩側。雙腳採取略寬於肩的深蹲站距，腳尖外展 15-20 度。\n\n張力創造：骨盆微收維持中立。深吸氣讓腹部與側面斜肌完全充滿氣體（360度擴張）。雙肩主動下沉，上背部肌群強力收緊，對抗槓鈴向下的剪力。雙腳旋入地面，啟動外旋扭矩。',
        ),
        MovementPhase(
          title: '離心收縮階段 / 下放 (Eccentric Phase)',
          content: '髖與膝同步解鎖，身體如同一個剛性鋁罐垂直下降。下蹲過程中，由於前載荷的槓鈴會不斷試圖將你的軀幹向前拉垮，你的上斜方肌、菱形肌與豎脊肌必須實施幾近瘋狂的等長對抗，保持挺胸。膝蓋順利前移並追蹤腳尖，下放耗時 2-3 秒。',
        ),
        MovementPhase(
          title: '最低點轉換期 / 減速與反轉 (Amortization Phase)',
          content: '蹲至大腿略低於平行地面（肘部通常會剛好落在大腿內側空間）達到轉換點。此時主動肌拉伸至極限，核心承受的屈曲力矩達到力學甜蜜點。必須在此死死咬住核心剛性，嚴禁含胸低頭或產生屁股眨眼（Buttwink）。利用底部肌梭的伸展反射，不作無謂停頓，迅速反轉重力。',
        ),
        MovementPhase(
          title: '向心收縮階段 / 推起 (Concentric Phase)',
          content: '足底三角釘死地面，全腳掌爆發性向下蹬地。大腦發力意象為「用你的胸骨與上背去頂撞天空」。保持軀幹角度與下蹲時一致，嚴禁臀部先抬高（變成早安蹲代償）。撐過膝彎 70 度的黏滯點時，髖部順勢積極向前推，使骨盆回到槓鈴正下方。',
        ),
        MovementPhase(
          title: '鎖定與恢復階段 (Lockout & Reset)',
          content: '身體完全站直，關節骨骼力學鎖定。由於槓鈴壓迫胸腔且核心極度緊繃，在此執行一次快速的「補氣/清潔呼吸」，切勿完全放鬆核心。重新確認肘彎緊貼肋骨，校準上背貨架，宣告下一次反覆。',
        ),
        MovementPhase(
          title: '核心提示詞 (Core Cues)',
          content: '「雙肘抱緊，死貼肋骨」（防止槓鈴滑脫，鎖定力矩）\n「用胸骨去撞天花板」（強迫上背與挺胸主導向心推起）\n「鋁罐剛性，屁股嚴禁先抬」（防止早安蹲代償，保護腰椎）',
        ),
      ],
      coreCues: [
        '「雙肘抱緊，死貼肋骨」— 鎖定力矩',
        '「用胸骨去撞天花板」— 挺胸主導推起',
        '「鋁罐剛性，屁股嚴禁先抬」— 防代償',
      ],
      muscleWeights: {
        MuscleGroup.quads: 1.0,
        MuscleGroup.core: 1.0,
        MuscleGroup.posteriorChain: 0.5,
      },
    ),

    'nordic': const MovementData(
      id: 'nordic',
      name: '北歐腿彎舉（奇數週）',
      englishName: 'Nordic Hamstring Curl',
      anatomyFocus: '**主動肌**：腿後肌群（半腱肌、半膜肌、股二頭肌長短頭）\n**穩定肌**：核心肌群（等長剛性維持）',
      mechanics: '單關節、**膝主導（Knee Flexion）**的純**離心特化**動作。在肌肉被強行拉長的極限狀態下注入極高密度的機械張力，是體能界公認強化後側鏈並杜絕受傷的**神級動作**。',
      phases: [
        MovementPhase(
          title: '預備與創造張力階段 (Set-up & Tension Generation)',
          content: '雙膝跪在厚實的軟墊上，雙腳踝必須被固定器、沉重槓鈴或夥伴的雙手死死鎖定在地面。軀幹從頭頂、脊椎、骨盆到膝蓋呈 90 度垂直於地面。\n\n張力創造：\n\n**核心最關鍵設定**：強力夾緊屁股（骨盆維持中立，嚴禁屈髖或翹屁股），腹肌同時內收鎖死。將整個上半身與大腿整合成一塊「絕對無法彎曲的剛性鋼板」，大腿後側肌群預先咬住等長張力。',
        ),
        MovementPhase(
          title: '離心收縮階段 / 下放 (Eccentric Phase)',
          content: '以膝關節為唯一旋轉軸心，控制身體緩慢、平穩地向前傾倒。下放速度越慢越好（理想為 3-5 秒）。此時，腿後肌群（Hamstrings）承受著近乎撕裂的離心負載。在傾倒過程中，骨盆必須與大腿始終保持在一條直線上，嚴禁透過折髖（翹屁股）來減輕大腿後側的力矩。',
        ),
        MovementPhase(
          title: '最低點轉換期 / 減速與反轉 (Amortization Phase)',
          content: '當身體傾倒至大約與地面呈 30-45 度夾角、大腿後側再也無法抵抗重力而即將「墜落」的瞬間達到過渡期。此時肌肉張力達到絕對極限。你必須維持鋼板剛性，雙手呈伏地挺身姿勢預備，在臉部接近地面時以雙手輕柔、充滿彈性地彈地承接，嚴禁直接面部撞擊地面。',
        ),
        MovementPhase(
          title: '向心收縮階段 / 拉回 (Concentric Phase)',
          content: '雙手觸地後，實施一次「極輕微、點到為止」的推地助推（僅補足無法向心拉回的力矩缺口）。隨後大腿後側肌群爆發性向心收縮（強力屈膝），將整塊如鋼板般的軀幹硬生生往後、往上拉回起始位。',
        ),
        MovementPhase(
          title: '鎖定與恢復階段 (Lockout & Reset)',
          content: '身體回到 90 度垂直跪姿。重新檢查骨盆是否有前傾或折髖。在大重量離心後，進行均勻呼吸，重新拉緊核心，校準鋼板外殼。',
        ),
        MovementPhase(
          title: '核心提示詞 (Core Cues)',
          content: '「屁股夾死，化身鋼板」（嚴禁折髖翹屁股舞弊）\n「用大腿後側死命抵抗地球」（壓榨高密度的離心張力）\n「輕微助推，後側咬緊拉回」（純粹用屈膝力量主導向心）',
        ),
      ],
      coreCues: [
        '「屁股夾死，化身鋼板」— 嚴禁折髖',
        '「用大腿後側死命抵抗地球」— 離心張力',
        '「輕微助推，後側咬緊拉回」— 屈膝主導向心',
      ],
      muscleWeights: {
        MuscleGroup.posteriorChain: 1.0,
      },
    ),

    'rdl': const MovementData(
      id: 'rdl',
      name: '單腿羅馬尼亞硬舉（偶數週）',
      englishName: 'Single-Leg Romanian Deadlift',
      anatomyFocus: '**主動肌**：腿後肌群（伸髖主導）、臀大肌\n**穩定肌**：臀中肌（單側額狀面骨盆穩定）、核心肌群',
      mechanics: '單側、**髖主導（Hip Extension）**的功能性鉸鏈動作。在閉鎖鏈狀態下對單側後側鏈進行**深度拉伸肌肥大**，同時對單側腳掌的「**足底三角**」平衡提出極高挑戰。',
      phases: [
        MovementPhase(
          title: '預備與創造張力階段 (Set-up & Tension Generation)',
          content: '單手持啞鈴或壺鈴（建議持在支撐腳的對側手 Contralateral，這能創造更好的抗旋轉力矩）。單腳站立，支撐腳雙膝微解鎖（維持 10-15 度微彎，隨後在此鎖定角度）。\n\n張力創造：支撐腳掌的大拇趾球、小拇趾球與腳跟形成穩固的「足底三角三角支點」死死咬住地面。收腹挺胸，空出的另一隻手往側邊伸展以維持平衡。核心收緊，在動作發生前將骨盆鎖定在絕對的水平面上，嚴禁高低骨盆。',
        ),
        MovementPhase(
          title: '離心收縮階段 / 下放 (Eccentric Phase)',
          content: '以支撐側的髖關節為唯一鉸鏈軸心。主動將支撐側的屁股向後方的牆面推動，軀幹順勢自然前傾。與此同時，非支撐腳（後腳）如同長槍一般，筆直、僵直地朝身體正後方延伸抬起。啞鈴緊貼著支撐腳的大腿前側垂直下放（耗時 2-3 秒），感受支撐側大腿後側與臀大肌被深度拉伸的張力。',
        ),
        MovementPhase(
          title: '最低點轉換期 / 減速與反轉 (Amortization Phase)',
          content: '當軀幹與後腳幾乎與地面平行、單側大腿後側感受到劇烈拉伸時達到最低點。這是單側平衡的極限盲區。此時，外側的臀中肌與核心對抗肌群必須等長死鎖，嚴禁非支撐側的髖關節向外「翻開」或轉動。咬住骨盆的對稱幾何，準備反轉。',
        ),
        MovementPhase(
          title: '向心收縮階段 / 推起 (Concentric Phase)',
          content: '支撐腳掌腳跟與大拇趾球全力「踩穿地面」，支撐側的臀大肌與腿後肌群爆發性向心收縮，強力伸髖將骨盆向前拉回。在回推過程中，核心維持抗旋轉剛性，引導後腳與軀幹同步、像天平一樣流暢地回到垂直位。',
        ),
        MovementPhase(
          title: '鎖定與恢復階段 (Lockout & Reset)',
          content: '身體回到單腳站立的垂直中立位，持重側臀肌強力收緊鎖定。在頂端重新校準足底三角的重心分配，調勻呼吸，核心重新 Bracing，再進入下一次反覆。',
        ),
        MovementPhase(
          title: '核心提示詞 (Core Cues)',
          content: '「後腳化為長槍向後刺」（確保軀幹與後腳呈天平式連動）\n「把屁股往後方的牆壁推」（引導正確的單側髖鉸鏈路徑）\n「踩穿地板，屁股嚴禁翻開」（強迫臀中肌鎖死骨盆水平面）',
        ),
      ],
      coreCues: [
        '「後腳化為長槍向後刺」— 天平式連動',
        '「把屁股往後方的牆壁推」— 單側髖鉸鏈',
        '「踩穿地板，屁股嚴禁翻開」— 臀中肌鎖死骨盆',
      ],
      muscleWeights: {
        MuscleGroup.posteriorChain: 1.0,
      },
    ),

    'leg_curl': const MovementData(
      id: 'leg_curl',
      name: '坐姿腿彎舉',
      englishName: 'Seated Leg Curl',
      anatomyFocus: '**主動肌**：腿後肌群（股二頭肌、半腱肌、半膜肌全面特化）\n**輔助肌**：比目魚肌',
      mechanics: '單關節、**膝主導（Knee Flexion）**的孤立動作。由於採用坐姿，髖關節處於約90度屈曲狀態，腿後肌群的骨盆起點被**預先拉長**。在此狀態下進行負重屈膝，能觸發極其強烈的**拉長狀態下伸展肌肥大（Stretch-mediated hypertrophy）**，效果完勝趴姿腿彎舉。',
      phases: [
        MovementPhase(
          title: '預備與創造張力階段 (Set-up & Tension Generation)',
          content: '緊貼椅背坐深。調整後側滾筒軸線，使其精確安放在阿基里斯腱（腳踝後側）上方。\n\n**最核心力學架設**：將機器上方的骨盆/大腿固定墊死死、極度緊繃地向下壓鎖在大腿股四頭肌上。\n\n張力創造：雙手死死抓緊座椅兩側的把手，主動將骨盆與下背部往後、往下「釘」在椅背上。本動作由頂端拉長狀態開始，發力循環由向心階段首發。',
        ),
        MovementPhase(
          title: '向心收縮階段 / 下拉 (Concentric Phase)',
          content: '大腿後側肌群強力向心起爆。發力意象為「用你的腳跟往座椅正下方深處死命摳回」。克服阻力將滾筒向後、向下扯動。當拉到路徑中段（膝彎約 90 度）的黏滯點時，雙手持續將屁股往椅墊死拉，確保骨盆絕不向前滑動或產生後傾借力，壓榨腿後肌群至完全縮短範圍。',
        ),
        MovementPhase(
          title: '鎖定與頂峰收縮階段 (Peak Contraction)',
          content: '滾筒拉至最底部、最接近座椅邊緣處。此時腿後肌群達到極限向心收縮。在最底部實施強制的「頂峰死鎖擠壓 1 秒鐘」，將機械張力與代謝壓力逼至極限。',
        ),
        MovementPhase(
          title: '離心收縮階段 / 回放 (Eccentric Phase)',
          content: '控制機器反向張力，耗時整整 2-3 秒緩慢放回。允許滾筒引導雙腿向上移動。在此過程中，大腿與骨盆依然死死鎖定在固定墊下，嚴禁下背部跟隨重量向前弓起。感受大腿後側肌肉在處於超長位移下，一邊承受負重一邊被生生拉長的離心張力。',
        ),
        MovementPhase(
          title: '最低點轉換期 / 伸展與反轉 (Amortization Phase)',
          content: '當雙腿幾乎完全伸直（膝關節接近完全鎖定，但仍維持 5 度微彎以保留安全張力）的頂端拉伸點時，達到轉換期。此時預拉伸的肌肥大訊號達到最高。嚴禁配重片在底部撞擊轟鳴（這代表張力洩漏）。在不失張力的前提下，順應伸展反射，立刻再次起爆向心下拉。',
        ),
        MovementPhase(
          title: '核心提示詞 (Core Cues)',
          content: '「骨盆釘死，嚴禁滑動」（強迫大腿墊發揮完全外殼鎖定作用）\n「腳跟往屁股深處摳」（專注膝屈發力軌跡）\n「緩慢回放，拉長後側」（壓榨拉長狀態下的離心肌肥大訊號）',
        ),
      ],
      coreCues: [
        '「骨盆釘死，嚴禁滑動」— 大腿墊外殼鎖定',
        '「腳跟往屁股深處摳」— 膝屈發力軌跡',
        '「緩慢回放，拉長後側」— 離心肌肥大',
      ],
      muscleWeights: {
        MuscleGroup.posteriorChain: 1.0,
      },
    ),

    // ─────────────────────── DAY 4 ───────────────────────
    'inverted_row': const MovementData(
      id: 'inverted_row',
      name: '仰臥划船',
      englishName: 'Inverted Row',
      anatomyFocus: '**主動肌**：中下斜方肌、菱形肌、後三角肌\n**輔助肌**：肱二頭肌、背闊肌',
      mechanics: '水平拉力的**閉鎖式動力鏈（CKC）**動作。要求整個身體做**等長平板支撐**，將力量從足底經由核心傳導至肩胛骨，特化背部厚度，並提供二頭肌腱與肘關節的安全過渡。',
      phases: [
        MovementPhase(
          title: '預備與創造張力階段 (Set-up & Tension Generation)',
          content: '將深蹲架上的空槓調整至大約腰部或下胸高度。身體鑽入槓下，雙手採取正握，握距略寬於肩。雙腳併攏伸直，腳跟著地，身體懸空。\n\n張力創造：執行 Kelly Starrett 的中線穩定序列：夾緊臀大肌鎖定骨盆，腹肌內收，肋骨下壓，將整個身體繃緊成一條直立的「剛性鋼板」。雙手死死抓緊槓鈴，雙肩主動下沉、遠離耳朵，背部肌肉預先咬住等長張力。',
        ),
        MovementPhase(
          title: '離心收縮階段 / 下放 (Eccentric Phase)',
          content: '控制身體自重，耗時 2-3 秒緩慢、平穩地下放軀幹。允許肩胛骨自然進行微幅的前引（Protraction），感受中下斜方肌、菱形肌與後三角肌被地心引力強行拉長，肌肉纖維承受高密度的離心機械張力。過程中，軀幹必須維持絕對剛性平板，嚴禁塌腰或屁股先下墜。',
        ),
        MovementPhase(
          title: '最低點轉換期 / 減速與反轉 (Amortization Phase)',
          content: '身體降至手臂接近完全伸直（保留 5 度微彎以防關節死鎖）的最底部。此時背部上背肌群被拉至最長，肌梭觸發強烈伸展反射。此處必須死死咬住全身腹內壓，配重自重嚴禁在底部產生任何鬆垮或卸力（張力洩漏），不進行無謂停頓，迅速將減速動能反轉為向心起爆力。',
        ),
        MovementPhase(
          title: '向心收縮階段 / 拉起 (Concentric Phase)',
          content: '上背肌群向心全面起爆。大腦發力意象為「用雙手手肘去猛烈撞擊身後的地面」。克服重力將胸骨下緣筆直拉向槓鈴。通過中段黏滯點時，維持背部不駝背，肩胛骨主動向中線強力靠攏擠壓（Scapular Retraction），強勢克服身體阻力。',
        ),
        MovementPhase(
          title: '鎖定與恢復階段 (Lockout & Reset)',
          content: '胸口下緣輕觸槓鈴。此時肩胛骨達到最大幅度的後收與下沉，上背部徹底夾緊。在頂端頂峰收縮強制鎖定 1 秒鐘。穩定呼氣，重新確認骨盆與下肢呈一直線，校準中線，準備迎接下一次控制離心。',
        ),
        MovementPhase(
          title: '核心提示詞 (Core Cues)',
          content: '「身體繃成鋼板，嚴禁下榻」（死守核心剛性）\n「手肘向後撞擊地面」（用背主導，摒除手臂代償）\n「胸口貼槓，夾緊肩胛骨」（壓榨中背厚度與向心極限）',
        ),
      ],
      coreCues: [
        '「身體繃成鋼板，嚴禁下榻」— 核心剛性',
        '「手肘向後撞擊地面」— 用背主導',
        '「胸口貼槓，夾緊肩胛骨」— 中背厚度',
      ],
      muscleWeights: {
        MuscleGroup.back: 1.0,
        MuscleGroup.sideDelt: 0.5,
        MuscleGroup.biceps: 0.5,
      },
    ),

    'incline_press': const MovementData(
      id: 'incline_press',
      name: '啞鈴上斜臥推',
      englishName: 'Dumbbell Incline Press',
      anatomyFocus: '**主動肌**：胸大肌上部（鎖骨頭）、肩部前三角肌\n**輔助肌**：肱三頭肌',
      mechanics: '上斜推力動作。長椅角度設定於**30度**（過高會變成全肩推），此幾何角度拉長了胸大肌上部的鎖骨端纖維力臂。啞鈴的自由度允許腕與肘關節進行**動態幾何微調**，對肩關節盂唇極其友善。',
      phases: [
        MovementPhase(
          title: '預備與創造張力階段 (Set-up & Tension Generation)',
          content: '坐在 30 度上斜椅上，雙手各持啞鈴，利用大腿將啞鈴頂回上胸兩側，順勢躺下。雙腳張開、全腳掌死死踩實地面。\n\n張力創造：雙肩主動向後收攏並向下沉，將肩胛骨死死扣在椅墊上，創造安全的胸椎拱背。深吸氣建立腹內壓（IAP）。雙手將啞鈴垂直舉起，前臂垂直於地面，轉動啞鈴使掌心朝向斜前外側（與軀幹呈約 45 度夾角）。',
        ),
        MovementPhase(
          title: '離心收縮階段 / 下放 (Eccentric Phase)',
          content: '雙肘解鎖，耗時 2-3 秒緩慢控制下放啞鈴。啞鈴軌跡垂直向下移動至胸大肌上部外側。雙肘與軀幹在幾何上必須始終維持 45-60 度夾角（嚴禁 90 度完全外展，這會導致肩峰下空間變窄造成夾擠）。感受胸上鎖骨端肌纖維被負重強行拉長的機械張力。',
        ),
        MovementPhase(
          title: '最低點轉換期 / 減速與反轉 (Amortization Phase)',
          content: '啞鈴下放至手柄與上胸外側持平，胸上肌群感受到極限拉伸。在此處實施「輕柔暫停 (Soft Pause)」1 秒鐘。此時必須死死咬住上背部的等長扣鎖，保持雙腳踩實（Leg Drive 預備），嚴禁含胸塌陷或讓啞鈴在最低點失去控制而劇烈晃動。',
        ),
        MovementPhase(
          title: '向心收縮階段 / 推起 (Concentric Phase)',
          content: '雙腳掌猛烈向地面發動 Leg Drive，力量傳導至上背。胸大肌上部與前三角肌爆發性向心收縮，將啞鈴向上、向內（朝中線微幅聚攏）推舉。當遇到離胸 10 公分的「黏滯點 (Sticking Point)」時，雙手想像「將雙肘內側彼此靠近（瘋狂擠壓胸肌）」，調整肱骨力臂，強勢穿過盲區。',
        ),
        MovementPhase(
          title: '鎖定與恢復階段 (Lockout & Reset)',
          content: '啞鈴在頂端鎖定，雙肘伸直，前臂垂直地面。注意：兩顆啞鈴在最高點嚴禁相互撞擊轟鳴（撞擊會導致肌肉瞬間卸力）。在頂端收緊胸肌，進行一次呼吸重置，為下一次反覆校準根基。',
        ),
        MovementPhase(
          title: '核心提示詞 (Core Cues)',
          content: '「肩胛夾死，腳掌蹬地」（建立推起貨架）\n「肘關節呈45度自然下放」（杜絕肩峰夾擠）\n「前臂垂直，用雙肘內側夾緊胸肌」（突破黏滯點與末端鎖定）',
        ),
      ],
      coreCues: [
        '「肩胛夾死，腳掌蹬地」— 建立推起貨架',
        '「肘關節呈45度自然下放」— 杜絕肩峰夾擠',
        '「前臂垂直，用雙肘內側夾緊胸肌」— 突破黏滯點',
      ],
      muscleWeights: {
        MuscleGroup.chest: 1.0,
        MuscleGroup.frontDelt: 0.5,
        MuscleGroup.triceps: 0.5,
      },
    ),

    'lat_pulldown': const MovementData(
      id: 'lat_pulldown',
      name: '寬握滑輪下拉',
      englishName: 'Wide-Grip Lat Pulldown',
      anatomyFocus: '**主動肌**：背闊肌（大範圍纖維）、大圓肌\n**輔助肌**：肱二頭肌、中下斜方肌',
      mechanics: '垂直拉力的**開放式動力鏈（OKC）**動作。作為引體向上的「降載優化」，透過寬握與大腿固定墊鎖定下肢，徹底分離核心搖晃代償，利用大位移精準刻劃**背部寬度**。',
      phases: [
        MovementPhase(
          title: '預備與創造張力階段 (Set-up & Tension Generation)',
          content: '雙手採取正握，握距約為肩寬的 1.5 倍抓緊橫槓。調整機器大腿固定墊，使其死死壓實並鎖定大腿股四頭肌。坐定，雙腳跟微微踮起踩實，使下肢與固定墊創造極高反作用力。\n\n張力創造：上半身微幅後仰（約 10-15 度），雙臂在頂端完全伸直。執行肩胛下沉：主動將雙肩向下壓，拉開耳朵與肩膀的距離，收緊核心，背闊肌外側與大圓肌預先咬住等長張力。',
        ),
        MovementPhase(
          title: '向心收縮階段 / 下拉 (Concentric Phase)',
          content: '背闊肌與大圓肌強力向心起爆。大腦發力意象為「用雙手手肘去砸碎你兩側的地面」。將橫槓沿著垂直軌跡下拉至上胸鎖骨高度。通過中段黏滯點時，保持挺胸不縮肩，手掌僅作為勾子，全面招募高閾值快肌纖維。',
        ),
        MovementPhase(
          title: '鎖定與頂峰收縮階段 (Peak Contraction)',
          content: '橫槓下拉至最接近上胸或鎖骨下緣。此時肩胛骨達到最大幅度的下沉與後收（夾背）。在最低點強制實施「頂峰收縮停頓 1.5 秒」，瘋狂擠壓闊背肌與大圓肌，逼迫血液大量回充以製造極大化代謝壓力。',
        ),
        MovementPhase(
          title: '離心收縮階段 / 回放 (Eccentric Phase)',
          content: '抵抗滑輪的配重張力，耗時整整 3 秒鐘緩慢、極其抗阻地放回橫槓。允許橫槓將手臂向上引導。在此過程中，骨盆與軀幹在大腿墊下保持絕對靜止，嚴禁含胸聳肩或整個人被重量往上帶走。感受闊背肌外側被生生拉長的離心肌肥大張力。',
        ),
        MovementPhase(
          title: '最低點轉換期 / 伸展與反轉 (Amortization Phase)',
          content: '橫槓回到最頂端，雙臂完全伸直，背闊肌處於拉長極限點。配重片在底部嚴禁落地撞擊（這會洩漏張力）。咬住最低過渡點的肌肉緊繃感，順應伸展反射，立刻重啟下一次向心下拉。',
        ),
        MovementPhase(
          title: '核心提示詞 (Core Cues)',
          content: '「大腿死壓固定墊」（分離核心代償）\n「手肘向身體兩側砸下」（摒除二頭肌死拉代償）\n「底部夾緊停頓，回放慢速拉長」（壓榨滿行程機械張力）',
        ),
      ],
      coreCues: [
        '「大腿死壓固定墊」— 分離核心代償',
        '「手肘向身體兩側砸下」— 摒除二頭肌代償',
        '「底部夾緊停頓，回放慢速拉長」— 滿行程張力',
      ],
      muscleWeights: {
        MuscleGroup.back: 1.0,
        MuscleGroup.biceps: 0.5,
        MuscleGroup.sideDelt: 0.5,
      },
    ),

    'dips': const MovementData(
      id: 'dips',
      name: '雙槓撐體',
      englishName: 'Dips',
      anatomyFocus: '**主動肌**：胸大肌下部、肩部前三角肌、肱三頭肌（鎖定階段）\n**穩定肌**：前鋸肌（肩胛等長穩定）',
      mechanics: '上肢推力的**閉鎖式動力鏈（CKC）**神級動作。身體懸空移動，對肩關節胸前帶提出極高的**動態穩定**要求。透過**軀幹前傾角度**調整可直接轉移胸肌下部受力力臂。',
      phases: [
        MovementPhase(
          title: '預備與創造張力階段 (Set-up & Tension Generation)',
          content: '雙手直臂支撐在雙槓上，雙肘鎖定。雙腿可以併攏伸直或交叉微彎，使身體完全懸空。\n\n張力創造：執行 Kelly Starrett 關節剛性序列：雙手手掌向外實施「試圖扭轉把手」的外旋力矩，主動啟動前鋸肌與上背，將肩胛骨牢牢穩定在後收下沉位。下壓肋骨、夾緊臀部，將軀幹鎖定成一塊緊繃的鋼板，深吸氣建立腹內壓（IAP）。',
        ),
        MovementPhase(
          title: '離心收縮階段 / 下放 (Eccentric Phase)',
          content: '雙肘解鎖，身體控制下降（耗時 2-3 秒）。\n\n**胸肌特化幾何設定**：下放時，軀幹主動前傾約 30 度，雙肘自然向後彎曲（嚴禁雙肘向兩側炸開）。這個前傾角度會拉長胸大肌下部的阻力臂，使胸大肌下緣與三角肌前束承受巨大的離心機械張力。',
        ),
        MovementPhase(
          title: '最低點轉換期 / 減速與反轉 (Amortization Phase)',
          content: '下降至大臂與地面平行（手肘彎曲呈 90 度）達到最低轉換點。此時肩關節前方剪力達到最高。你必須死死咬住核心剛性與上背穩定，嚴禁含胸聳肩（這會導致肩關節盂唇因關節不穩而急性受傷借力）。在此轉換點穩住 0.5 秒，預備反轉。',
        ),
        MovementPhase(
          title: '向心收縮階段 / 推起 (Concentric Phase)',
          content: '胸大肌與三頭肌爆發性向心起爆。發力意象為「用手掌死命把雙槓向下推離身體」。維持軀幹大約 30 度的前傾夾角，將身體筆直推回。通過中段黏滯點時，前三角肌與肱三頭肌強力向心收縮介入，確保向上推進速度不減慢。',
        ),
        MovementPhase(
          title: '鎖定與恢復階段 (Lockout & Reset)',
          content: '身體推回最高點，雙肘完全伸直鎖定。雙肩主動下沉、遠離耳朵（前鋸肌強力下壓肩胛）。在頂端呼氣，重啟腹內壓 Bracing，校準外旋力矩，迎戰下一把重複。',
        ),
        MovementPhase(
          title: '核心提示詞 (Core Cues)',
          content: '「手掌外旋扭轉把手，鎖死肩膀」（建立安全的肩關節盂唇空間）\n「身體前傾30度，手肘向後折」（特化胸下緣力臂）\n「雙肩遠離耳朵，手掌向下推碎雙槓」（頂端骨骼幾何鎖定）',
        ),
      ],
      coreCues: [
        '「手掌外旋扭轉把手，鎖死肩膀」— 肩關節安全',
        '「身體前傾30度，手肘向後折」— 胸下緣力臂',
        '「雙肩遠離耳朵，手掌向下推碎雙槓」— 頂端鎖定',
      ],
      muscleWeights: {
        MuscleGroup.chest: 1.0,
        MuscleGroup.frontDelt: 0.5,
        MuscleGroup.triceps: 0.5,
      },
    ),

    'trx_plank': const MovementData(
      id: 'trx_plank',
      name: 'TRX 平板撐',
      englishName: 'TRX Plank',
      anatomyFocus: '**主動肌**：核心肌群（腹直肌、腹橫肌、腹內/外斜肌、多裂肌）\n**穩定肌**：前鋸肌（等長主動推地）',
      mechanics: '**終極核心終結技**：將雙腳懸吊在 TRX 的不穩定表面上。這種微小的晃動會迫使大腦的神經系統瘋狂募集平時靜態平板撐刺激不到的深層腹橫肌與微小穩定肌群，提供無與倫比的抗伸展與抗側屈整合。',
      phases: [
        MovementPhase(
          title: '預備與創造張力階段 (Set-up & Tension Generation)',
          content: '調整 TRX 吊繩至距地面約 20-30 公分高度。雙腳穿入 TRX 腳環中，身體轉向面朝地面，前臂呈三角形穩固撐地（手肘精確位於肩膀正下方）。\n\n張力創造：夾緊臀大肌鎖定骨盆，肋骨下壓，深吸氣。前臂主動向下推地（前鋸肌發力），將胸椎微幅後拱，徹底消除翼狀肩胛。此時身體懸空，由頭頂至腳跟維持在絕對的水平中立線上。',
        ),
        MovementPhase(
          title: '抗晃動離心對抗 (Eccentric Phase)',
          content: '等長維持期：當 TRX 產生微小的左右或前後晃動（試圖讓你的骨盆塌陷或凹下背）時，你的腹直肌與腹斜肌必須進行極其細微的離心抗阻拉長，去鎖住、拉住這個即將偏離的中線軌跡，等長承受高密度的張力挑戰。',
        ),
        MovementPhase(
          title: '瞬時動態修正點 (Amortization Phase)',
          content: '發生在身體晃動達到最大偏離幅度的瞬間（即將塌腰或骨盆歪斜的盲區邊緣）。此時深層腹橫肌的神經機械感受器瞬間拉響警報。你必須死死咬住中線剛性，核心兩側瞬間爆發等長剛性，將這個偏離力道硬生生在半空中剎車減速，預備回推。',
        ),
        MovementPhase(
          title: '向心回充剛性 (Concentric Phase)',
          content: '腹橫肌與骨盆底肌群強力向心/等長收縮。發力意象為「將你的肋骨與骨盆骨頭強烈向內壓縮、靠攏」。把微幅晃動偏離的軀幹，硬生生往中線正中央拉回、校準。前臂持續向下壓碎地板，維持中軸脊椎的絕對剛性線條。',
        ),
        MovementPhase(
          title: '鎖定與恢復階段 (Lockout & Reset)',
          content: '身體重回完美的水平對稱平板位（密封鋁罐狀態）。由於核心承受著極高密度的代謝壓力，此時嚴禁完全憋氣（會引發血壓驟升），必須執行「高頻率、小口短促的清潔呼吸」。在維持密封剛性的前提下排出 CO₂，直到 45 秒結束，緩慢跪地重置。',
        ),
        MovementPhase(
          title: '核心提示詞 (Core Cues)',
          content: '「前臂向下壓碎地板，頂起上背」（根除翼狀肩胛）\n「屁股夾死，腹部往內吸緊」（防止凹下背與腰椎剪力）\n「身體化身鋼鐵鋁罐，拒絕晃動塌腰」（深層腹橫肌剛性轟炸）',
        ),
      ],
      coreCues: [
        '「前臂向下壓碎地板，頂起上背」— 根除翼狀肩胛',
        '「屁股夾死，腹部往內吸緊」— 防凹下背',
        '「身體化身鋼鐵鋁罐，拒絕晃動塌腰」— 深層核心',
      ],
      muscleWeights: {
        MuscleGroup.core: 1.0,
      },
    ),

    // ─────────────────────── 進階動作庫 ───────────────────────
    'pallof_press': const MovementData(
      id: 'pallof_press',
      name: '帕羅夫推舉',
      englishName: 'Pallof Press',
      anatomyFocus: '**主動肌**：腹橫肌、腹內斜肌、腹外斜肌、腰方肌\n**輔助肌**：臀中肌（維持骨盆對稱）、前鋸肌、前三角肌',
      mechanics: '純粹的**抗旋轉（Anti-Rotation）**功能性訓練。\n\n滑輪或彈力帶從側面施加了一個水平剪力力矩，試圖扭轉你的軀幹。核心肌群必須透過強烈的**等長收縮（Isometric Contraction）**建立動態剛性，守住中線。',
      phases: [
        MovementPhase(
          title: '預備與創造張力階段 (Set-up & Tension Generation)',
          content: '雙腳與肩同寬平行站立，側對滑輪機。雙手扣緊 D 型把手，將把手拉至胸口正中央。\n\n**張力創造**：肋骨下壓，夾緊屁股鎖定骨盆。深吸氣建立高密度**腹內壓（IAP）**。雙腳旋入地面，啟動臀中肌。此時，側向的拉力已經拉開，核心必須在雙手貼胸的狀態下，預先咬住「抗扭轉」的等長張力。',
        ),
        MovementPhase(
          title: '離心收縮階段 / 下放 (Eccentric Phase)',
          content: '控制側向拉力，耗時 2–3 秒緩慢將把手沿著中線收回胸前。在此過程中，側向剪力會隨著阻力臂縮短而逐漸減小，但核心絕不能鬆懈，必須維持軀幹絕對靜止，嚴禁肩膀或骨盆向滑輪方向偏轉。',
        ),
        MovementPhase(
          title: '最低點轉換期 / 減速與反轉 (Amortization Phase)',
          content: '當把手輕觸胸口正中央的瞬間達到轉換期。此時阻力臂最小，但神經系統必須保持高度警覺。在此死死等長鎖定 0.5 秒，嚴禁含胸或讓把手撞擊胸骨借力，隨即平穩地向外反轉力道。',
        ),
        MovementPhase(
          title: '向心收縮階段 / 推起 (Concentric Phase)',
          content: '核心肌群爆發性發力，雙臂沿著身體正中線，將把手筆直向前推出。**隨著雙手向前延伸，側向拉力的「阻力臂」劇烈拉長，核心所承受的旋轉力矩會呈線性飆升**。撐過雙臂半伸直的黏滯點，全力維持身體幾何中立。',
        ),
        MovementPhase(
          title: '鎖定與恢復階段 (Lockout & Reset)',
          content: '雙臂在正前方完全伸直鎖定。此時阻力臂達到最大值，側向拉力對中線的破壞力達到頂峰。**在正前方強制進行等長死鎖維持 2 秒鐘**。執行短促的清潔呼吸，維持可樂罐剛性，再進入控制收回。',
        ),
      ],
      coreCues: [
        '「軀幹化身水泥鋼柱」— 拒絕任何微小扭轉',
        '「把手死守身體中線」— 確保推舉軌跡不偏斜',
        '「遠端極限死鎖 2 秒」— 壓榨最高密度的抗旋轉張力',
      ],
      muscleWeights: {
        MuscleGroup.core: 1.0,
        MuscleGroup.sideDelt: 0.3,
      },
    ),

    'pushup_plus': const MovementData(
      id: 'pushup_plus',
      name: '進階伏地挺身',
      englishName: 'Push-Up Plus',
      anatomyFocus: '**主動肌**：前鋸肌（肩胛骨前引與貼緊胸廓）、胸大肌、前三角肌、肱三頭肌\n**輔助肌**：腹直肌、腹橫肌、股四頭肌（等長平板支撐）',
      mechanics: '**閉鎖式動力鏈（CKC）**的水平推力優化動作。\n\n相比常規伏地挺身，它在向心頂端增加了一個**肩胛骨極限前引（Scapular Protraction）**的完整行程，能有效活化前鋸肌，專治翼狀肩胛，建立完美的肩胛胸壁關節穩定度。',
      phases: [
        MovementPhase(
          title: '預備與創造張力階段 (Set-up & Tension Generation)',
          content: '雙手略寬於肩撐地，手掌精確位於肩膀正下方，指尖微幅外旋。雙腳併攏，身體呈標準高位平板支撐。\n\n**張力創造**：夾緊屁股、大腿收緊、肋骨下壓，建立完美中線。雙手手掌對地面實施「試圖撕裂地板」的外旋扭矩，將肩胛骨後收下沉，鎖死肩關節盂唇，胸肌與前鋸肌預先繃緊。',
        ),
        MovementPhase(
          title: '離心收縮階段 / 下放 (Eccentric Phase)',
          content: '雙肘解鎖，耗時 2–3 秒緩慢下放身體。軀幹維持鋼板剛性，雙肘自然向斜後方彎曲，與軀幹呈 45–60 度夾角。感受胸大肌與前三角肌被體重強行拉長，肩胛骨在後側自然、順暢地向中線靠攏（Retraction）。',
        ),
        MovementPhase(
          title: '最低點轉換期 / 減速與反轉 (Amortization Phase)',
          content: '胸口下緣距離地面約 3 公分時達到最低點。此時胸肌拉伸至極限，必須在此維持 0.5 秒的死停暫停，徹底杜絕利用胸腔下塌回彈的舞弊行為。咬住核心，順應肌梭的伸展反射準備反轉。',
        ),
        MovementPhase(
          title: '向心收縮階段 / 推起 (Concentric Phase)',
          content: '胸大肌與三頭肌爆發性向心收縮，手掌全力「壓碎地面」將身體推回。當推到常規伏地挺身的頂端時（雙臂伸直），**動作絕不停止——神經系統持續灌注力量，用意志力驅動雙手再度瘋狂推地，將上背部向天空高高頂起**（執行肩胛骨極限前引）。',
        ),
        MovementPhase(
          title: '鎖定與恢復階段 (Lockout & Reset)',
          content: '抵達「Plus」的最高點，此時上背部因肩胛骨完全分開而呈現完美的圓弧拱起，前鋸肌達到極限向心收縮。**在最高點死鎖擠壓 1–2 秒**。吐氣，隨後有控制地放鬆前引幅度，重置肩胛下沉，進入下一次控制離心。',
        ),
      ],
      coreCues: [
        '「手掌壓碎地板，核心繃緊」— 維持鋼鐵平板',
        '「推舉到頂不停止，繼續推向天空」— 引導 Plus 前引行程',
        '「把兩片肩胛骨完全分開」— 精準活化前鋸肌意象',
      ],
      muscleWeights: {
        MuscleGroup.chest: 0.7,
        MuscleGroup.frontDelt: 0.5,
        MuscleGroup.triceps: 0.5,
        MuscleGroup.core: 0.3,
      },
    ),

    'deadlift': const MovementData(
      id: 'deadlift',
      name: '傳統槓鈴硬舉',
      englishName: 'Conventional Deadlift',
      anatomyFocus: '**主動肌**：臀大肌、腿後肌群（半腱肌、半膜肌、股二頭長頭）、豎脊肌\n**輔助肌**：背闊肌（等長鎖定槓鈴）、斜方肌、菱形肌、前臂屈肌群',
      mechanics: '大重量、軸向加載的**髖鉸鏈（Hip Hinge）**王牌動作。\n\n雙腳採取窄站距，槓鈴貼近脛骨，重力線直穿**中足（Mid-foot）**。相比相撲硬舉，傳統硬舉的軀幹前傾角度較大，這拉長了腰椎的水平阻力臂，能產生極高功率的後側鏈神經募集。\n\n> 首下一律由向心階段直接爆發起槓，反覆間遵循以下閉環。',
      phases: [
        MovementPhase(
          title: '預備與創造張力階段 (Set-up & Tension Generation)',
          content: '雙腳約與髖同寬站立，槓鈴精確對齊中足。屈髖、微屈膝下蹲，雙手採取略寬於大腿的外側握距抓緊槓鈴，脛骨主動前傾貼緊槓身。\n\n**張力創造**：挺胸、展肩，雙肘微微內夾，執行「把槓鈴折彎並拉斷」的神經意象，瞬間拉緊配重線並瘋狂啟動背闊肌，將槓鈴死死鎖在脛骨上。深吸氣，360 度撐滿腹內壓，脊椎解耦中立。',
        ),
        MovementPhase(
          title: '離心收縮階段 / 下放 (Eccentric Phase)',
          content: '頂端鎖定後，雙膝微解鎖，隨即主動折髖**將屁股向正後方的牆面推動**。槓鈴宛如剃刀般死死貼著大腿皮膚垂直下放。當槓鈴抗阻下降滑過膝蓋高度的瞬間，膝關節才順勢彎曲，引導槓片平穩、垂直地降落至地面。下放耗時 2 秒，嚴禁直接自由落體砸地。',
        ),
        MovementPhase(
          title: '最低點轉換期 / 減速與反轉 (Amortization Phase)',
          content: '槓片輕觸地面的瞬間（Touch-and-Go）或死重靜止狀態。此時腰椎剪力達到最高峰。你必須死死扣住腹內壓與背闊肌張力，**結構嚴禁含胸龜背或讓骨盆產生前傾/後傾的微小晃動**。利用神經系統的瞬時剛性，將重力減速轉化為蹬地向心力。',
        ),
        MovementPhase(
          title: '向心收縮階段 / 推起 (Concentric Phase)',
          content: '神經全面起爆。**發力意象絕非「用腰把槓鈴拉起來」，而是「用雙腿把地板死命踩穿」**（Leg Drive）。股四頭肌首先收縮驅動起槓；當槓鈴推進過膝、滑動至大腿中段的黏滯點時，臀大肌與腿後肌群強烈收縮接管，將骨盆強勢向前推動伸髖，完成力的傳導。',
        ),
        MovementPhase(
          title: '鎖定與恢復階段 (Lockout & Reset)',
          content: '身體完全站直，雙膝、雙髖完全伸直。臀大肌強力收縮鎖死骨盆。\n\n> **嚴禁**為了追求鎖定而將胸椎與腰椎向後過度凹背（Hyperextension）。\n\n在頂端挺胸，執行清潔呼吸重新 Bracing，拉緊背闊肌貨架，準備迎戰下一把。',
        ),
      ],
      coreCues: [
        '「拉緊配重線，背闊肌鎖死」— 起槓前張力傳導',
        '「用雙腿踩穿地板」— 由腿主導起槓，保護下背',
        '「槓鈴貼死大腿，屁股前推」— 過膝後強烈伸髖鎖定',
      ],
      muscleWeights: {
        MuscleGroup.posteriorChain: 1.0,
        MuscleGroup.back: 0.5,
        MuscleGroup.quads: 0.3,
      },
    ),

    'sumo_deadlift': const MovementData(
      id: 'sumo_deadlift',
      name: '相撲硬舉',
      englishName: 'Sumo Deadlift',
      anatomyFocus: '**主動肌**：股四頭肌、臀大肌、大收肌（內收肌群特化）\n**輔助肌**：豎脊肌（相較傳統硬舉，負擔大幅減輕）、斜方肌、核心肌群',
      mechanics: '超寬站距的下肢推拉複合動作。\n\n由於雙腿大幅度外展與外旋，**極大地縮短了軀幹與槓鈴重力線之間的水平阻力臂**。這允許軀幹在起槓時維持極度直立，將腰椎剪力降至最低，轉而極度壓榨股四頭肌與大內收肌群的剪切輸出。',
      phases: [
        MovementPhase(
          title: '預備與創造張力階段 (Set-up & Tension Generation)',
          content: '採取超寬站距（腳掌貼近槓片），雙腳尖強烈朝外旋轉約 45 度以上。骨盆垂直下沉，雙臂在雙腿內側垂直下垂，採取對稱抓握。\n\n**張力創造**：挺胸，主動將**骨盆與腹股溝極度向前貼近槓鈴**。雙膝強力向外推，使其幾何軌跡與腳尖完全對齊。雙手拉緊配重線，收緊闊背肌。深吸氣撐爆腹內壓，在起槓前創造一個「將身體塞進槓鈴下方」的極限張力。',
        ),
        MovementPhase(
          title: '離心收縮階段 / 下放 (Eccentric Phase)',
          content: '頂端鎖定後，維持軀幹近乎垂直於地面的幾何角度。控制骨盆垂直向下坐落，**雙膝在下降過程中必須持續主動向兩側外推**，確保槓鈴沿著絕對筆直的垂線貼身放回地面。下放耗時 2 秒，嚴禁屁股先往後翹。',
        ),
        MovementPhase(
          title: '最低點轉換期 / 減速與反轉 (Amortization Phase)',
          content: '槓片輕觸地面的盲區。由於相撲硬舉底部行程極短且力學幾何極其敏感，此處只要骨盆微幅向後漂移，力臂就會崩潰。你必須在觸地瞬間維持骨盆極度貼槓的幾何位置，咬死腹內壓，神經系統瞬間反轉力道。',
        ),
        MovementPhase(
          title: '向心收縮階段 / 推起 (Concentric Phase)',
          content: '神經意象起爆：**「雙腳掌向左右兩側死命推開地面」**。股四頭肌與內收肌群產生排山倒海的向心收縮，將重量蹬離地面。由於相撲硬舉的黏滯點就在「離地前 5 公分」，只要槓鈴離地，立即將臀大肌水平向前「塞進（Wedging）」槓鈴正下方，完成鎖定。',
        ),
        MovementPhase(
          title: '鎖定與恢復階段 (Lockout & Reset)',
          content: '雙膝、雙髖完全伸直，身體呈絕對垂直的一線幾何。臀肌與內收肌同步鎖死。在頂端挺胸，執行一次清潔呼吸，重新微調雙膝外推的扭矩，維持剛性外殼準備下一把。',
        ),
      ],
      coreCues: [
        '「將身體強行塞進槓鈴下」— 起槓前極大化貼槓幾何',
        '「雙腳向兩側推開地板」— 起槓時活化四頭與內收肌',
        '「骨盆水平塞進槓鈴」— 離地後瞬間伸髖鎖定',
      ],
      muscleWeights: {
        MuscleGroup.quads: 1.0,
        MuscleGroup.posteriorChain: 0.7,
        MuscleGroup.back: 0.3,
      },
    ),

    'cossack_squat': const MovementData(
      id: 'cossack_squat',
      name: '哥薩克蹲',
      englishName: 'Cossack Squat',
      anatomyFocus: '**主動肌（支撐側）**：股四頭肌、臀大肌、臀中肌（單側骨盆等長剛性穩定）\n**特化肌（延伸側）**：大收肌、長收肌（極限拉長狀態下抗阻）、腿後肌群',
      mechanics: '多維度（額狀面與矢狀面交織）的進階單側深蹲。\n\n它融合了單側下肢的超大行程深蹲，與對側直腿肌群的**拉長狀態下阻抗（Stretch-mediated resistance）**。這對支撐側的踝關節背屈能力、骨盆三維抗傾斜能力提出了骨灰級的生物力學要求。',
      phases: [
        MovementPhase(
          title: '預備與創造張力階段 (Set-up & Tension Generation)',
          content: '雙手可在胸前抱拳（或持壺鈴做前載荷）。採取超寬站距（約 2 至 2.5 倍肩寬），雙腳掌預設平行朝前（或微朝外）。\n\n**張力創造**：收腹挺胸，肋骨下壓，深吸氣建立腹內壓。將身體軸心穩定在中央，雙側核心與臀肌預先緊繃，建立對抗單側橫向移動的剛性地基。',
        ),
        MovementPhase(
          title: '離心收縮階段 / 下放 (Eccentric Phase)',
          content: '將身體重心向單側（支撐側）橫向橫移，隨即支撐側屈髖、屈膝控制下蹲（耗時 3 秒）。與此同時，**延伸側（直腿側）必須保持絕對伸直，且延伸側的腳尖必須主動向天空翻轉旋出**（以腳跟為軸心旋轉）。感受延伸側大腿內側內收肌群被瘋狂拉扯、撕裂的離心機械張力。',
        ),
        MovementPhase(
          title: '最低點轉換期 / 減速與反轉 (Amortization Phase)',
          content: '當支撐側大腿深蹲至低於平行線、延伸側內收肌達到極限拉伸點時，達到最低轉換期。此時單側骨盆極易發生傾斜或扭轉。你必須將支撐側足底三角釘死地面，核心側向抗屈曲拉滿，**在此強制死停 0.5 秒消除動能**，準備橫向向心反轉。',
        ),
        MovementPhase(
          title: '向心收縮階段 / 推起 (Concentric Phase)',
          content: '支撐側全腳掌爆發性向下「踩碎地面」，股四頭肌的主動膝伸與臀大肌的強烈伸髖共同起爆。大腦發力意象為「沿著斜向弧線將地板推離身體」。將重心垂直且橫向推回中線，延伸側直腿順勢收回腳掌平貼地面。',
        ),
        MovementPhase(
          title: '鎖定與恢復階段 (Lockout & Reset)',
          content: '身體回到最初的超寬站距垂直中立位，雙腿完全伸直，骨盆回歸正中央。在此重啟一次大口呼吸，重新校準橫向核心剛性，宣告下一次反覆（向另一側或同側執行）。',
        ),
      ],
      coreCues: [
        '「直腿側腳尖轉向天空」— 解剖學解鎖髖關節，極限拉伸內收肌',
        '「支撐側足底釘死，垂直下蹲」— 確保單側四頭與臀肌吃重',
        '「用單腿踩碎地板推回中線」— 專注單側向心驅動意象',
      ],
      muscleWeights: {
        MuscleGroup.quads: 0.8,
        MuscleGroup.posteriorChain: 0.5,
      },
    ),

    'single_arm_row': const MovementData(
      id: 'single_arm_row',
      name: '單臂啞鈴划船',
      englishName: 'Single-Arm DB Row',
      anatomyFocus: '**主動肌**：背闊肌、大圓肌、後三角肌、菱形肌、中下斜方肌\n**輔助肌**：肱二頭肌、前臂屈肌群（抓握）、核心肌群（抗旋轉）',
      mechanics: '**單側水平拉力**的開放式動力鏈（OKC）動作。\n\n由於是單側負重，啞鈴的重力會對脊椎產生強烈的旋轉力矩，迫使核心肌群必須進行高強度的**抗旋轉（Anti-Rotation）**等長收縮以維持骨盆與胸廓的水平。',
      phases: [
        MovementPhase(
          title: '預備與創造張力階段 (Set-up & Tension Generation)',
          content: '雙腳採取弓步站姿（或單膝、單手撐在臥推椅上）。非工作側手掌死死撐住支撐面，鎖死肩胛骨。工作側軀幹平行於地面，手持啞鈴自然下垂。\n\n**張力創造**：下壓肋骨、收緊腹部，執行中線穩定。工作側肩胛骨主動下沉、遠離耳朵（啟動背闊肌）。雙腳與支撐手三點建立剛性地基，全面抗衡啞鈴試圖扭轉軀幹的剪力。',
        ),
        MovementPhase(
          title: '離心收縮階段 / 下放 (Eccentric Phase)',
          content: '控制啞鈴的重力，耗時 2–3 秒緩慢、抗阻地下放。允許肩胛骨在最底部自然前引（Protraction），感受背闊肌外側與大圓肌被完全拉長、撕裂的機械張力。過程中軀幹如鋼板般維持水平，嚴禁骨盆向側邊歪斜。',
        ),
        MovementPhase(
          title: '最低點轉換期 / 減速與反轉 (Amortization Phase)',
          content: '啞鈴降至最底部、背肌達到極限預拉伸的盲區。此時核心的抗旋轉張力達到最高峰。必須在此維持 0.5 秒死停，徹底抹殺任何身體晃動的動能，順應肌梭的伸展反射，準備向心起爆。',
        ),
        MovementPhase(
          title: '向心收縮階段 / 推起 (Concentric Phase)',
          content: '背部肌群向心全力起爆。**發力意象絕非「垂直向上提拉啞鈴」，而是「用工作側手肘劃出一道弧線，猛烈撞擊後方的髖關節」**。這能極大化背闊肌的伸髖功能，減少二頭肌代償。通過中段黏滯點時，肩胛骨向中線強力收攏（Retraction）。',
        ),
        MovementPhase(
          title: '鎖定與恢復階段 (Lockout & Reset)',
          content: '啞鈴手柄貼近肋骨側邊，手肘高度超越軀幹。此時中下斜方肌與菱形肌極限收縮，上背完全夾緊。**在頂端實施頂峰收縮鎖定 1 秒鐘**。保持呼氣，維持骨盆水平對稱，隨後平穩進入下一次控制離心。',
        ),
      ],
      coreCues: [
        '「撐緊地基，身體拒絕搖晃」— 鎖定抗旋轉核心',
        '「手肘滑向屁股」— 用背主導弧線軌跡，摒除手臂代償',
        '「頂端捏緊肩胛骨」— 壓榨中背厚度的向心極限',
      ],
      muscleWeights: {
        MuscleGroup.back: 1.0,
        MuscleGroup.biceps: 0.5,
        MuscleGroup.core: 0.3,
      },
    ),

    'turkish_getup': const MovementData(
      id: 'turkish_getup',
      name: '土耳其起立',
      englishName: 'Turkish Get-Up',
      anatomyFocus: '**主動肌**：旋轉肌群（岡上/岡下/小圓/肩胛下肌，極致等長穩定）、三角肌\n**輔助肌**：核心肌群（腹直/腹橫/斜肌/腰方肌，360 度多維度穩定）、臀大肌、股四頭肌',
      mechanics: '跨越三維空間（矢狀面、額狀面、水平面）的高階多關節功能性整合動作。\n\n要求負重臂在身體經歷「躺臥、側滾、撐地、高橋、穿腿、弓步、站立」的動態軌跡中，幾何重力線必須**永遠垂直穿過肩、肘、腕關節並對齊中足**，對肩關節盂唇提出骨灰級的動態鎖定要求。',
      phases: [
        MovementPhase(
          title: '預備與創造張力階段 (Set-up & Tension Generation)',
          content: '呈側臥胎兒姿，雙手將壺鈴抱至胸前，隨後翻轉仰臥。工作側單臂將壺鈴垂直推向天空，肘關節死鎖。工作側膝蓋彎曲、腳掌踩實地面；非工作側手臂與下肢向外張開 45 度平貼地面。\n\n**張力創造**：執行**「肩關節打包（Pack the shoulder）」**，想像將肱骨頭死死吸入肩關節囊深處，背闊肌與前鋸肌同步咬住張力。深吸氣撐滿腹內壓，雙眼死死盯住壺鈴，建立全身剛性貨架。',
        ),
        MovementPhase(
          title: '離心收縮階段 / 下放 (Eccentric Phase)',
          content: '從站姿開始，控制重力緩慢向後跨出弓步、膝蓋著地；隨後軀幹側屈，非工作側手掌精確尋找地面平貼。在此離心過程中，核心與臀肌承受多維度的抗阻拉長，負重臂必須像一根不變形的鋼柱，死死抵抗試圖拉偏重心的拉力。',
        ),
        MovementPhase(
          title: '最低點轉換期 / 減速與反轉 (Amortization Phase)',
          content: '發生在動作的核心過渡期（如：由高橋架準備穿腿的瞬間，或躺臥準備側滾起身的盲區）。此時身體的支撐幾何大範圍改變，關節受力力臂達到最不穩定的臨界點。你必須在各個節點死死停頓 0.5 秒，校準重力線，嚴禁任何一處關節解耦鬆榻。',
        ),
        MovementPhase(
          title: '向心收縮階段 / 推起 (Concentric Phase)',
          content: '身體全面性向心驅動。工作側足底蹬地，側滾起身上身至手肘、隨後撐起至手掌；臀部強力抬高（高橋架），將非工作側腿流暢地向後「穿過」並跪地改呈弓步平衡，最終雙腿蹬地挺身站立。整個過程中，**上肢神經系統唯一任務是「持續向天空出拳」**，維持荷載垂直。',
        ),
        MovementPhase(
          title: '鎖定與恢復階段 (Lockout & Reset)',
          content: '身體完全站直，雙腳併攏，壺鈴重力線經由筆直的手臂直穿足底中央。此時由骨骼幾何完美鎖定承重。在頂端執行一次高質量的清潔呼吸，將神經系統、血壓與核心剛性重新 Reset，準備進入下一反向離心階段。',
        ),
      ],
      coreCues: [
        '「眼神死盯壺鈴」— 維持神經中樞本體感覺回饋',
        '「把肩膀往地裡壓 / 向天空出拳」— 極致鎖定肩盂唇',
        '「在每個節點按暫停鍵」— 確保幾何結構穩固，嚴禁盲目連貫',
      ],
      muscleWeights: {
        MuscleGroup.frontDelt: 0.7,
        MuscleGroup.core: 0.8,
        MuscleGroup.posteriorChain: 0.3,
      },
    ),

    'hip_thrust': const MovementData(
      id: 'hip_thrust',
      name: '槓鈴臀推',
      englishName: 'Barbell Hip Thrust',
      anatomyFocus: '**主動肌**：臀大肌（頂峰極限縮短特化）、大收肌\n**輔助肌**：腿後肌群、股四頭肌、豎脊肌（等長剛性穩定）',
      mechanics: '水平加載的純粹**髖伸（Hip Extension）**動作。\n\n與深蹲、硬舉不同，臀推的阻力方向垂直於軀幹，這徹底消除了腰椎的軸向剪力。力學甜蜜點落在**髖關節完全伸直的「極限縮短位置」**，此時臀大肌的機械張力與運動單元招募達到絕對的最大值。',
      phases: [
        MovementPhase(
          title: '預備與創造張力階段 (Set-up & Tension Generation)',
          content: '上背部（肩胛骨下緣邊沿）橫靠在臥推椅上。槓鈴加裝厚護墊，精確滾動安放在骨盆腹股溝處。雙腳平貼地面，站距約與肩同寬，腳尖自然朝外 15–30 度。\n\n**張力創造**：雙手抓穩槓鈴。執行「下巴死死收緊（鎖定下巴）」，雙眼直視前方。深吸氣撐起巨大的腹內壓。雙腳掌施加外旋扭矩，臀肌在動作發生前預先進入 100% 緊繃抗阻狀態。',
        ),
        MovementPhase(
          title: '離心收縮階段 / 下放 (Eccentric Phase)',
          content: '控制槓鈴重力，耗時 2–3 秒緩慢下放骨盆。**核心最關鍵力學：你的脊椎與骨盆必須結合為一塊鋼板，以臥推椅邊緣為唯一軸心整體旋轉下降**。嚴禁透過凹下背（腰椎過度伸展/屈曲）來下放重量。雙眼始終死死盯著前方牆面，嚴禁頭部隨身體後仰看天花板。',
        ),
        MovementPhase(
          title: '最低點轉換期 / 減速與反轉 (Amortization Phase)',
          content: '當骨盆降至接近地面、臀大肌被拉伸至盲區時達到最低點。配重片嚴禁完全著地卸力。在此咬住核心剛性，輕柔暫停 0.5 秒。此時臀肌的腱梭感應到拉伸，順應強烈伸展反射，神經系統瞬間反轉力道。',
        ),
        MovementPhase(
          title: '向心收縮階段 / 推起 (Concentric Phase)',
          content: '臀大肌全面性暴烈起爆。**發力意象為「用你的雙腳跟，死命把地球踩穿」**（Leg Drive）。由下肢反作用力驅動骨盆沿著弧線垂直向上推舉。通過中段黏滯點時，維持下巴收緊、雙眼看前方，強迫力量純粹由骨盆後傾與髖伸主導，嚴禁利用腰椎凹背借力。',
        ),
        MovementPhase(
          title: '鎖定與恢復階段 (Lockout & Reset)',
          content: '骨盆推至最高點，小腿在幾何上與地面呈絕對的 90 度垂直，軀幹與大腿呈水平 tabletop（桌面）。**此時執行強烈的「骨盆後傾（Posterior Pelvic Tilt, PPT）」**，將臀大肌像捏碎硬幣一樣死死擠壓鎖定 1–2 秒鐘。吐氣，重新 Bracing 核心，準備下一次重複。',
        ),
      ],
      coreCues: [
        '「盯著前方，收緊下巴」— 死鎖頸椎與腰椎，根除下背代償',
        '「用腳跟踩穿地面」— 激活最強下肢伸髖動力鏈',
        '「頂端夾緊屁股，做一張水平桌子」— PPT 極限鎖定，壓榨臀肌縮短位',
      ],
      muscleWeights: {
        MuscleGroup.posteriorChain: 1.0,
      },
    ),

    'hanging_leg_raise': const MovementData(
      id: 'hanging_leg_raise',
      name: '懸垂舉腿',
      englishName: 'Hanging Leg Raise',
      anatomyFocus: '**主動肌**：腹直肌、腹外斜肌、腹內斜肌、髂腰肌（髖屈肌群）\n**輔助肌**：股直肌、前臂屈肌群（等長抓握）',
      mechanics: '開放式動力鏈的下腹部核心特化動作。\n\n許多人在此動作中僅執行了「髖關節屈曲」，導致髂腰肌過度代償而下背酸痛。生物力學上，必須實現**「骨盆後傾與脊椎屈曲（骨盆向胸口捲動）」**，才能真正讓腹直肌下部產生高張力的向心縮短。',
      phases: [
        MovementPhase(
          title: '預備與創造張力階段 (Set-up & Tension Generation)',
          content: '雙手正握懸掛於單槓上。執行**主動懸掛（Active Hang）**：雙肩下沉、遠離耳朵，活化前鋸肌與下斜方肌。雙腿併攏伸直。\n\n**張力創造**：夾緊臀部、大腿繃緊，**將雙腿稍微置於身體垂直線的前方約 5–10 度**。這能預先讓前側核心咬住等長張力，徹底切斷身體因地心引力產生前後晃動（鐘擺效應）的力學底座。',
        ),
        MovementPhase(
          title: '離心收縮階段 / 下放 (Eccentric Phase)',
          content: '控制雙腿自重，耗時 2–3 秒極其緩慢地放回起始位。腹直肌與核心肌群在此時承受高密度的離心抗阻拉長。你必須用核心死死踩住剎車，嚴禁雙腿直接摔落，否則產生的動能會引發災難性的身體晃動。',
        ),
        MovementPhase(
          title: '最低點轉換期 / 減速與反轉 (Amortization Phase)',
          content: '當雙腿回到預設的前傾 5 度起點時達到過渡期。**此處是阻斷鐘擺效應的「生死臨界點」**。你必須在此強制停頓 1 秒鐘，將身體的任何晃動動能完全降為零，咬住腹肌底部的緊繃張力，準備純淨起爆。',
        ),
        MovementPhase(
          title: '向心收縮階段 / 推起 (Concentric Phase)',
          content: '腹式核心神經全面起爆。**發力意象絕非「把腳抬起來」，而是「努力將你的恥骨（骨盆底部）向上捲動，去撞擊你的肋骨下緣」**。隨著膝蓋/足尖上推，強烈命令骨盆產生大角度的後傾捲動，逼迫腹直肌下部在極端縮短位瘋狂收縮。',
        ),
        MovementPhase(
          title: '鎖定與恢復階段 (Lockout & Reset)',
          content: '雙腿（或雙膝）高高舉起，骨盆完全離開身體垂直中立面並向上翻轉，腹肌完全揉縮擠壓。**在最高點實施頂峰死鎖 0.5–1 秒鐘**。將肺部空氣完全吐盡（極大化腹橫肌壓縮），隨後平穩進入控制離心。',
        ),
      ],
      coreCues: [
        '「肩膀遠離耳朵，雙腿微微前傾」— 封鎖鐘擺回彈的根基',
        '「把骨盆捲向胸口」— 用腹肌捲骨盆，切斷髂腰肌代償',
        '「頂端吐盡空氣，死停 1 秒」— 壓榨核心極限張力',
      ],
      muscleWeights: {
        MuscleGroup.core: 1.0,
      },
    ),

    'landmine_press': const MovementData(
      id: 'landmine_press',
      name: '單臂地雷管斜推',
      englishName: 'Single-Arm Landmine Press',
      anatomyFocus: '**主動肌**：胸大肌鎖骨頭（上胸）、三角肌前束、前鋸肌（頂端肩胛骨上旋與前引）\n**輔助肌**：肱三頭肌、對側腹斜肌群（抗側屈等長穩定）',
      mechanics: '單側站姿（或半跪姿）的**非線性軌跡推力動作**。\n\n地雷管的固定軸創造了一條「介於水平推與垂直推之間」的斜向幾何弧線，允許肩胛骨在完美的**肩胛骨平面（Scapular Plane）**內自然滑動，對肩峰下空間極其友善。單側加載同時對對側核心提出了極高的**抗側屈（Anti-Lateral Flexion）**張力要求。',
      phases: [
        MovementPhase(
          title: '預備與創造張力階段 (Set-up & Tension Generation)',
          content: '站姿（雙腳平行或弓步）或半跪姿。單手抓緊槓鈴袖口末端，將槓鈴頂端架設在工作側肩膀前側前方。非工作手握拳垂於身側或叉腰。\n\n**張力創造**：夾緊臀部、收緊腹部，執行中線穩定。**對側的腹內外斜肌與腰方肌強力繃緊**，死死抗衡槓鈴試圖將你軀幹向工作側拉塌的側向力矩。前臂與地雷管角度保持力學垂直，前束預先咬住張力。',
        ),
        MovementPhase(
          title: '離心收縮階段 / 下放 (Eccentric Phase)',
          content: '控制槓鈴沿著其固定的幾何弧線控制下放（耗時 2–3 秒）。手肘自然向斜前方內夾，與軀幹呈約 30–45 度夾角（肩胛平面）。感受上胸、前三角肌與三頭肌承受抗阻拉長的機械張力。軀幹如雕像般僵直，嚴禁向工作側歪斜。',
        ),
        MovementPhase(
          title: '最低點轉換期 / 減速與反轉 (Amortization Phase)',
          content: '槓鈴降至接近上肩前側的力學甜蜜點。此時胸前帶與對側核心的抗阻剪力達到最高峰。在此實施「輕柔暫停」0.5 秒。死死咬住上背與核心，嚴禁槓鈴撞擊身體借力，順應伸展反射準備反轉。',
        ),
        MovementPhase(
          title: '向心收縮階段 / 推起 (Concentric Phase)',
          content: '上胸與三角肌前束向心爆發起爆。足底死踩地面，**發力意象為「沿著地雷管的弧線，將槓鈴向斜前方狠狠推碎」**。當推至路徑中段黏滯點時，維持軀幹中立，嚴禁透過身體轉動或側彎來作弊借力，純粹由上肢與肩胛動力鏈驅動。',
        ),
        MovementPhase(
          title: '鎖定與恢復階段 (Lockout & Reset)',
          content: '手臂完全伸直。**核心力學終點：主動將肩膀向前、向上送出（執行肩胛骨的前引與上旋 Scapular Protraction/Upward Rotation）**。這能給予前鋸肌極限收縮，並徹底釋放肩關節壓力。在頂端「leaning into the bar（身體微幅順勢前傾頂鎖）」1 秒。均勻呼吸，重新 Reset 核心。',
        ),
      ],
      coreCues: [
        '「對側核心繃緊，身體化身雕像」— 封鎖側彎代償',
        '「手肘朝斜前方自然下放」— 死守肩胛平面，保護盂唇',
        '「推到頂端，向斜前方全力出拳」— 活化前鋸肌，極限鎖定',
      ],
      muscleWeights: {
        MuscleGroup.chest: 0.7,
        MuscleGroup.frontDelt: 0.8,
        MuscleGroup.triceps: 0.3,
        MuscleGroup.core: 0.3,
      },
    ),

    'reverse_sled': const MovementData(
      id: 'reverse_sled',
      name: '倒退負重雪橇',
      englishName: 'Reverse Sled Drag',
      anatomyFocus: '**主動肌**：股四頭肌（特化股內側肌 VMO）、臀大肌\n**輔助肌**：小腿肌肉群、核心肌群（中軸等長姿態穩定）',
      mechanics: '**純向心收縮（Concentric-Dominant）**的功能性與體能整合動作。\n\n由於是倒退行走，每次跨步都由腳尖著地過渡到腳跟，並在末端執行極高強度的**膝關節完全伸直鎖定（Terminal Knee Extension, TKE）**。此動作完全沒有離心階段，因此造成的肌肉微剪切損傷與延遲性肌肉酸痛（DOMS）極低，是打造鋼鐵膝關節與四頭肌耐力的神級動作。',
      phases: [
        MovementPhase(
          title: '預備與創造張力階段 (Set-up & Tension Generation)',
          content: '面對雪橇，雙手抓緊韁繩把手（或將腰帶扣鎖於骨盆）。身體向後傾斜（約 15–30 度），將體重作為槓桿拉緊韁繩，配重線張力瞬間拉滿。\n\n**張力創造**：雙膝微彎，下壓肋骨，核心鎖死。大腦發力意象為「建立一個絕對不會被拉散的鋼鐵骨架」，上背斜方肌與核心等長收縮，股四頭肌預先咬住極高密度的等長張力。',
        ),
        MovementPhase(
          title: '離心收縮階段 / 下放 (Eccentric Phase)',
          content: '當你向後邁出單腳，**足尖（前腳掌）首先擊向地面承重**。此時，雖然動作整體是向心主導，但在足尖著地的瞬間，該側股四頭肌必須進行極其短暫、微幅的離心抗阻「剎車」，去承接雪橇向前拉扯你軀幹的動量。下肢關節維持在抗阻彈性狀態。',
        ),
        MovementPhase(
          title: '最低點轉換期 / 減速與反轉 (Amortization Phase)',
          content: '發生在**前腳掌完全踩實地面、而腳跟即將壓實的瞬時盲區**。此時單腿由「承接衝擊」瞬間切換為「發力推進」。你必須維持骨盆高度不晃動，足底三角釘死，神經系統以最快速度完成方向反轉，杜絕任何張力洩漏。',
        ),
        MovementPhase(
          title: '向心收縮階段 / 推起 (Concentric Phase)',
          content: '該側股四頭肌全面性向心暴烈起爆。**發力意象為「用你的前腳掌，死命把地球向前、向遠處推開」**。強力伸膝，驅動整個身體與骨盆平穩、強勢地向後橫移，拉動超重雪橇。力量經由繃緊的剛性軀幹無損傳導至韁繩。',
        ),
        MovementPhase(
          title: '鎖定與恢復階段 (Lockout & Reset)',
          content: '步態的末端：**膝關節達到完全的伸直鎖定（TKE）**。此時，負責穩定髕骨骨骼幾何的**股內側肌（VMO）**達到極限向心收縮。在單步鎖定頂端擠壓四頭肌 0.1 秒，隨後對側腳順勢向後邁出，重啟下一次預備張力與步態循環。',
        ),
      ],
      coreCues: [
        '「重心後傾，拉緊生命線」— 利用體重槓桿，嚴禁含胸',
        '「用足尖抓地，把地球向前推走」— 激活最強四頭肌向心動力鏈',
        '「每一步，膝蓋完全伸直鎖死」— 精準轟炸 VMO，強化膝關節剛性',
      ],
      muscleWeights: {
        MuscleGroup.quads: 1.0,
      },
    ),
  };
}
