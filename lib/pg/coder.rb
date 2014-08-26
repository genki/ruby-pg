#!/usr/bin/env ruby

module PG

	class Coder
		def initialize(params={})
			params.each do |key, val|
				send("#{key}=", val)
			end
		end

		def dup
			self.class.new(to_h)
		end

		def to_h
			{
				oid: oid,
				format: format,
				name: name,
			}
		end

		def ==(v)
			self.class == v.class && to_h == v.to_h
		end

		def marshal_dump
			Marshal.dump(to_h)
		end

		def marshal_load(str)
			initialize Marshal.load(str)
		end

		def inspect
			str = self.to_s
			oid_str = " oid=#{oid}" unless oid==0
			format_str = " format=#{format}" unless format==0
			name_str = " #{name.inspect}" if name
			str[-1,0] = "#{name_str} #{oid_str}#{format_str}"
			str
		end
	end

	class CompositeCoder < Coder
		def to_h
			super.merge!({
				elements_type: elements_type,
				needs_quotation: needs_quotation?,
			})
		end

		def inspect
			str = super
			str[-1,0] = " elements_type=#{elements_type.inspect} #{needs_quotation? ? 'needs' : 'no'} quotation"
			str
		end
	end
end # module PG

