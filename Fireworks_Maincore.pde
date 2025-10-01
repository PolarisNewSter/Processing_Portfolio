// ==========================
// Mainタブ
// 花火全体の制御（setup, draw, mouse入力など）
// ==========================

import processing.sound.*;  // ★ライブラリimportは最初のタブに1回だけ書く

ArrayList<Firework> fireworks;  // 複数の花火を管理するリスト

void setup() {                               
  size(600, 600);                            // ウィンドウのサイズ設定
  fireworks = new ArrayList<Firework>();     // 花火リストを生成
  background(0);                             // 背景を黒で初期化
  
  initSound(this);                           // サウンド初期化（Soundタブの関数）
  smooth();                                  // アンチエイリアス
}

void draw() {                                // 毎フレーム呼ばれる描画ループ
  background(0);                             // フレームごとに黒で塗り直す（残像消し）
  
  for (int i = fireworks.size()-1; i >= 0; i--) { 
    Firework f = fireworks.get(i);           // i番目の花火を取り出す
    f.update();                              // 花火の更新処理（打ち上げor爆発粒）
    f.show();                                // 花火の描画
    if (f.done()) {                          // 完全に消えたか判定
      fireworks.remove(i);                   // 消えたらリストから削除
    }
  }
}

void mousePressed() {                        // マウスクリック時
  if (mouseButton == LEFT) {                 // 左クリックのみ
    fireworks.add(new Firework(mouseX, mouseY)); // クリック位置を爆発高度に設定
  }
}
