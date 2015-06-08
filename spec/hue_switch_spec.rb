require_relative 'spec_helper.rb'
require 'hue_switch'

describe "Switch" do
	context "New Switch without parameters" do
		it "creates a new Switch" do
			Switch.new.class.should == Switch
		end

		it "turns on all lights" do
			result = Switch.new { on }
			result.body == {:on=>true}
		end 

		it "turns off all lights" do
			result = Switch.new { off }
			result.body == {:on=>false}
		end

		it "assigns a color to all lights" do
			result = Switch.new { color :blue}
			result.body == {:hue=>46920}
		end

		it "takes multiple parameters" do
			result = Switch.new { color :reading ; brightness 127 ; on }
			result.body = {:ct=>346, :bri=>127, :on=>true}
		end
	end

	context "Existing switch" do
		before(:all) do
			@switch = Switch.new
		end

		it "controls a light group" do
			groups = @switch.instance_variable_get(:@groups).keys
			@switch.lights groups[rand(groups.length)].to_sym
			result = @switch.on
			result.first.keys == ["success"]
		end
	end
end