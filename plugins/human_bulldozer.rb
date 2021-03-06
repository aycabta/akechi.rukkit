# encoding: utf-8

import 'org.bukkit.Sound'
import 'org.bukkit.entity.Player'
import 'org.bukkit.event.entity.EntityDamageEvent'
import 'org.bukkit.potion.PotionEffectType'

module HumanBulldozer
  extend self
  extend Rukkit::Util

  @num_blocks ||= {}
  @bonus_time ||= {}

  def on_block_break(evt)
    block = evt.block
    player = evt.player

    if @bonus_time[player.name]
      istack = player.item_in_hand
      istack.durability -= 1 if istack.durability > 0
      return
    end

    @num_blocks[player.name] ||= {}
    @num_blocks[player.name][block.type] ||= 0
    @num_blocks[player.name][block.type] += 1

    if @num_blocks[player.name][block.type] > 200
      @num_blocks[player.name][block.type] = 0

      text = "[HUMAN BULLDOZER] #{player.name} broke 200 #{block.type}s. #{player.name} can dig faster for 1 minute, without consuming pickaxe!"
      Lingr.post text
      broadcast text

      player.add_potion_effect(PotionEffectType::FAST_DIGGING.create_effect(sec(60), 5))

      @bonus_time[player.name] = true
      later sec(60) do
        @bonus_time[player.name] = false

        play_sound(player.location, Sound::AMBIENCE_CAVE  , 1.0, 0.3)
        text = "[HUMAN BULLDOZER] #{player.name}'s bonus time ended."
        Lingr.post(text)
        broadcast(text)
      end


      play_sound(player.location, Sound::DONKEY_DEATH , 1.0, 0.0)
      play_sound(player.location, Sound::LEVEL_UP , 0.8, 1.5)

      player.send_message '(HPが全回復し、expちょっともらえます)'
      player.health = player.max_health
      10.times do |i|
        later sec(i) do
          loc = player.location
          later sec(1) do
            orb = spawn(loc, EntityType::EXPERIENCE_ORB)
            orb.experience = 1
          end
        end
      end
    end
  end

  def on_command(sender, command, label, args)
    return unless label == 'rukkit'
    args = args.to_a
    return unless args.shift == 'human-bulldozer'

    soons = @num_blocks[sender.name].select {|k, v| 120 < v && v <= 180 }
    verysoons = @num_blocks[sender.name].select {|k, v| 180 < v }

    text =
      if soons.empty? && verysoons.empty?
        "[HUMAN BULLDOZER] #{sender.name} Nothing to report"
      else
        "[HUMAN BULLDOZER] #{sender.name} soon: #{soons.keys.join ', '}, very soon: #{verysoons.keys.join ', '}"
      end
    Lingr.post(text)
    broadcast(text)
  end
end
