# encoding: utf-8
import 'org.bukkit.Material'

module RareMaterialNotification
  extend self
  extend Rukkit::Util

  def on_player_pickup_item(evt)
    player = evt.player
    item = evt.item

    msg =
      case item.item_stack.type
      when Material::DIAMOND_ORE
        'ダイアモンド鉱石ゲットだぜ！'
      when Material::LAPIS_ORE
        'ラピスラズリ鉱石 ヽ(*´∀｀)ノ ｷｬｯﾎｰｲ!!'
      when Material::EMERALD_ORE
        'エメラルド鉱石 ｷﾀﾜｧ*:.｡..｡.:*･ﾟ (n‘∀‘)ηﾟ･*:.｡..｡.:* ﾐ ☆'
      else
        nil
      end

    player.chat(msg) if msg
  end
end