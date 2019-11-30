local bound2      = require "modules.bound2"
local vec2      = require "modules.vec2"
local DBL_EPSILON = require("modules.constants").DBL_EPSILON

describe("bound2:", function()
	it("creates an empty bound2", function()
		local a = bound2()
		assert.is.equal(0, a.min.x)
		assert.is.equal(0, a.min.y)
		assert.is.equal(0, a.max.x)
		assert.is.equal(0, a.max.y)
	end)

	it("creates a bound2 from vec2s", function()
		local a = bound2(vec2(1,2), vec2(4,5))
		assert.is.equal(1, a.min.x)
		assert.is.equal(2, a.min.y)
		assert.is.equal(4, a.max.x)
		assert.is.equal(5, a.max.y)
	end)

	it("creates a bound2 using new()", function()
		local a = bound2.new(vec2(1,2), vec2(4,5))
		assert.is.equal(1, a.min.x)
		assert.is.equal(2, a.min.y)
		assert.is.equal(4, a.max.x)
		assert.is.equal(5, a.max.y)
	end)

	it("creates a bound2 using at()", function()
		local a = bound2.at(vec2(4,5), vec2(1,2))
		assert.is.equal(1, a.min.x)
		assert.is.equal(2, a.min.y)
		assert.is.equal(4, a.max.x)
		assert.is.equal(5, a.max.y)
	end)

	it("clones a bound2", function()
		local a = bound2(vec2(1,2), vec2(4,5))
		local b = a:clone()
		a.max = new vec2(9,9)
		assert.is.equal(a.min, b.min)
		assert.is.not_equal(a.max, b.max)
	end)

	it("uses bound2 check()", function()
		local a = bound2(vec2(4,2), vec2(1,5)):check()
		assert.is.equal(1, a.min.x)
		assert.is.equal(2, a.min.y)
		assert.is.equal(4, a.max.x)
		assert.is.equal(5, a.max.y)
	end)

	it("queries a bound2 size", function()
		local a = bound2(vec2(1,2), vec2(4,6))
		local v = a:size()
		local r = a:radius()
		assert.is.equal(3, v.x)
		assert.is.equal(4, v.y)

		assert.is.equal(1.5, r.x)
		assert.is.equal(2, r.y)
	end)

	it("sets a bound2 size", function()
		local a = bound2(vec2(1,2), vec2(4,5))
		local b = a:with_size(vec2(1,1))

		assert.is.equal(1, a.min.x)
		assert.is.equal(2, a.min.y)
		assert.is.equal(4, a.max.x)
		assert.is.equal(5, a.max.y)

		assert.is.equal(1, b.min.x)
		assert.is.equal(2, b.min.y)
		assert.is.equal(2, b.max.x)
		assert.is.equal(3, b.max.y)
	end)

	it("queries a bound2 center", function()
		local a = bound2(vec2(1,2), vec2(3,4))
		local v = a:center()
		assert.is.equal(2, v.x)
		assert.is.equal(3, v.y)
	end)

	it("sets a bound2 center", function()
		local a = bound2(vec2(1,2), vec2(3,4))
		local b = a:with_center(vec2(1,1))

		assert.is.equal(1, a.min.x)
		assert.is.equal(2, a.min.y)
		assert.is.equal(3, a.max.x)
		assert.is.equal(4, a.max.y)

		assert.is.equal(0, b.min.x)
		assert.is.equal(0, b.min.y)
		assert.is.equal(2, b.max.x)
		assert.is.equal(2, b.max.y)
	end)

	it("sets a bound2 size centered", function()
		local a = bound2(vec2(1,2), vec2(3,4))
		local b = a:with_size_centered(vec2(4,4))

		assert.is.equal(1, a.min.x)
		assert.is.equal(2, a.min.y)
		assert.is.equal(3, a.max.x)
		assert.is.equal(4, a.max.y)

		assert.is.equal(0, b.min.x)
		assert.is.equal(1, b.min.y)
		assert.is.equal(4, b.max.x)
		assert.is.equal(5, b.max.y)
	end)

	it("insets a bound2", function()
		local a = bound2(vec2(1,2), vec2(5,10))
		local b = a:inset(vec2(1,2))

		assert.is.equal(1, a.min.x)
		assert.is.equal(2, a.min.y)
		assert.is.equal(5, a.max.x)
		assert.is.equal(10, a.max.y)

		assert.is.equal(2, b.min.x)
		assert.is.equal(4, b.min.y)
		assert.is.equal(4, b.max.x)
		assert.is.equal(8, b.max.y)
	end)

	it("outsets a bound2", function()
		local a = bound2(vec2(1,2), vec2(5,6))
		local b = a:outset(vec2(1,2))

		assert.is.equal(1, a.min.x)
		assert.is.equal(2, a.min.y)
		assert.is.equal(5, a.max.x)
		assert.is.equal(6, a.max.y)

		assert.is.equal(0, b.min.x)
		assert.is.equal(0, b.min.y)
		assert.is.equal(6, b.max.x)
		assert.is.equal(8, b.max.y)
	end)

	it("offsets a bound2", function()
		local a = bound2(vec2(1,2), vec2(5,6))
		local b = a:offset(vec2(1,2))

		assert.is.equal(1, a.min.x)
		assert.is.equal(2, a.min.y)
		assert.is.equal(5, a.max.x)
		assert.is.equal(6, a.max.y)

		assert.is.equal(2, b.min.x)
		assert.is.equal(4, b.min.y)
		assert.is.equal(6, b.max.x)
		assert.is.equal(8, b.max.y)
	end)

	it("tests for points inside bound2", function()
		local a = bound2(vec2(1,2), vec2(4,5))

		assert.is_true(a:contains(vec2(2,3)))
		assert.is_not_true(a:contains(vec2(0,3)))
		assert.is_not_true(a:contains(vec2(5,3)))
		assert.is_not_true(a:contains(vec2(2,1)))
		assert.is_not_true(a:contains(vec2(2,6)))
		assert.is_not_true(a:contains(vec2(2,3)))
		assert.is_not_true(a:contains(vec2(2,3)))
	end)

	it("extends a bound2 with a point", function()
		local min = vec2(1,2)
		local max = vec2(4,5)
		local downright = vec2(8,8)
		local downleft = vec2(-4,8)
		local top = vec2(2, 0)

		local a = bound2(min, max)
		local temp

		temp = a:extend(downright)
		assert.is_true(a.min == min and a.max == max)
		assert.is_true(temp.min == min and temp.max == downright)
		temp = a:extend(downleft)
		assert.is_true(temp.min == vec2(-4,2) and temp.max == vec2(4,8))
		temp = a:extend(top)
		assert.is_true(temp.min == vec2(1,0) and temp.max == max)
	end)

	it("extends a bound with another bound", function()
		local min = vec2(1,2)
		local max = vec2(4,5)
		local leftexpand = bound2.new(vec2(0,0), vec2(1.5, 6))
		local rightexpand = bound2.new(vec2(1.5,0), vec2(5, 6))

		local a = bound2(min, max)
		local temp

		temp = a:extend_bound(leftexpand)
		assert.is_equal(temp.min, vec2(0,0))
		assert.is_equal(temp.max, vec2(4,6))
		temp = temp:extend_bound(rightexpand)
		assert.is_equal(temp.min, vec2(0,0))
		assert.is_equal(temp.max, vec2(5,6))
	end)
	
	it("checks for bound2.zero", function()
		assert.is.equal(0, bound2.zero.min.x)
		assert.is.equal(0, bound2.zero.min.y)
		assert.is.equal(0, bound2.zero.max.x)
		assert.is.equal(0, bound2.zero.max.y)
	end)
end)
