require 'trello'

board_id = ENV['TRELLO_BOARD_ID']
api_key = ENV['TRELLO_API_KEY']
member_token = ENV['TRELLO_MEMBER_TOKEN']

Trello.configure do |config|
  config.developer_public_key = api_key
  config.member_token = member_token
end

board = Trello::Board.find(board_id)

lists = board.lists
members = lists[0].cards.collect {|card| card.members[0]}
puts "members list #{members.map {|m| m.full_name}}"

gardenerCard = lists[1].cards[0]
current = gardenerCard.members[0]
puts "current member #{current.full_name}"

i = members.index(current)
nextMember = members[i + 1 == members.size ? 0 : i + 1]
puts "next member #{nextMember.full_name}"

gardenerCard.remove_member(current)
gardenerCard.add_member(nextMember)

puts "sending out an email to #{nextMember.email}"
system ("echo You are the new community gardener for this week. | mail -s \"Community Gardener\" -r \"jenkins-dev.eng.lab.tlv.redhat.com(Jenkins for Devs)\" #{nextMember.email}")
