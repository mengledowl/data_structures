#!/usr/bin/ruby

class Node
	attr_accessor :value, :next

	def initialize(value, next_node)
		@value = value
		@next = next_node
	end
end

class LinkedList
	attr_accessor :head

	def initialize(value)
		@head = Node.new(value, nil)
	end

	def insert(value, position)
		node = Node.new(value, nil)

		if position == 0
			node.next = self.head
			self.head = node
		else
			prev_node = nil
			next_node = self.head

			position.times do
				prev_node = next_node
				next_node = next_node.next

				break unless next_node
			end

			prev_node.next = node
			node.next = next_node
		end
	end

	def remove(*opts)
		opts = opts[0]
		type = opts.keys.first

		raise ArgumentError, "Option key #{type} is not a recognized removal method" unless %w(index node value).include?(type.to_s)

		send(:"remove_by_#{type}", opts[:"#{type}"])
	end

	private

	def remove_by_index(index)
		prev_node = nil
		to_remove = self.head

		index.times do
			prev_node = to_remove
		 	to_remove = to_remove.next
		end

		if prev_node.nil?
			self.head = to_remove.next
		else
			prev_node.next = to_remove.next
		end
	end

	def remove_by_node(node)
		if node == self.head
			self.head = head.next
			return
		end

		prev_node = self.head

		loop do
			if prev_node.next == node
				prev_node.next = node.next
				break
			else
				prev_node = prev_node.next
				break if prev_node.nil?
			end
		end
	end

	def remove_by_value(val)
		prev_node = self.head
		target_node = prev_node.next

		if prev_node.value == val
			self.head = target_node
		else
			loop do
				break if target_node.nil?

				if target_node.value == val
					prev_node.next = target_node.next
					break
				else
					prev_node = target_node
					target_node = target_node.next
				end
			end
		end		
	end
end

list = LinkedList.new(1)
list.head.next = Node.new(2, Node.new(3, Node.new(4, Node.new(5, nil))))

puts "INSERT BY INDEX"

puts "\n-->position 0:".upcase
list.insert(0, 0)
p list

puts "\n-->position: 1".upcase
list.insert(0.5, 1)
p list

puts "\n-->last available position (7)".upcase
list.insert(6, 7)
p list

puts "\nREMOVE BY POSITION"

puts "\n-->POSITION 0"
list.remove(index: 0)
p list

puts "\n-->POSITION 1"
list.remove(index: 1)
p list

puts "\n-->LAST POSITION (5)"
list.remove(index: 5)
p list

puts "\nREMOVE BY NODE"

puts "\n-->WHEN IT IS THE HEAD"
n = list.head
list.remove(node: n)
p list

puts "\n-->SPECIFIC NODE"
n = list.head.next
puts "removing: #{n}"
list.remove(node: n)
p list

puts "\nREMOVE BY VALUE"

puts "\n-->VALUE #{list.head.next.value}" 
val = list.head.next.value
puts "removing: #{val}"
list.remove(value: val)
p list

puts "\n-->WHEN NONE PRESENT FOR SPECIFIED VALUE" 
val = 10000000
list.remove(value: val)
p list

puts "\nREMOVE WITH UNRECOGNIZED OPTION"
begin
	list.remove(not_allowed: 1)
rescue ArgumentError => e
	puts e.message
	p list
end