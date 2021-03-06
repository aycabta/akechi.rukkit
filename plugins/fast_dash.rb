import 'org.bukkit.Bukkit'
import 'org.bukkit.entity.Squid'
import 'org.bukkit.Material'

module FastDash
  extend self

  def on_player_toggle_sprint(evt)
    return if evt.player.passenger && Squid === evt.player.passenger
    if evt.sprinting? && !evt.player.passenger
      case evt.player.location.clone.add(0, -1, 0).block.type
      when Material::SAND
        evt.cancelled = true
      when Material::COBBLE_WALL
        evt.player.walk_speed = 1.0 if evt.player.location.y > 78
      else
        evt.player.walk_speed = 0.4
      end
    else
      evt.player.walk_speed = 0.2
    end
  end

  def on_food_level_change(evt)
    case
    when evt.entity.walk_speed >= 1.0
      evt.cancelled = true
    when evt.entity.level > 2 && evt.entity.walk_speed >= 0.4
      evt.cancelled = true
    end
  end
end
