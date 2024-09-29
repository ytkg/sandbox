require 'open-uri'
require 'yaml'

def load_menus(source)
  content = URI.open(source).read
  YAML.safe_load(content, aliases: true, symbolize_names: true)
end

def index_by_id(menus)
  menus[:all].to_h { |item| [item[:id], item] }
end

def diff_menu_names(from_menus, to_menus)
  from = index_by_id(from_menus)
  to = index_by_id(to_menus)
  (to.keys - from.keys).map { |id| to[id][:name] }
end

def print_diff(title, items)
  return if items.empty?

  puts "## #{title}"
  items.each { |item| puts "- #{item}" }
end

remote_url = 'https://raw.githubusercontent.com/ytkg/komeda/main/config/menus.yaml'
local_path = 'config/menus.yaml'

remote_menus = load_menus(remote_url)
local_menus = load_menus(local_path)

print_diff('Add', diff_menu_names(remote_menus, local_menus))
print_diff('Del', diff_menu_names(local_menus, remote_menus))
