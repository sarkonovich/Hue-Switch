require_relative 'spec_helper.rb'
require 'hue_switch'

describe "Switch" do
	context "user not authorized" do
		it "raises an error" do
			class SwitchTest < Switch
				def initialize
					@user = "043658A90"
					@ip = HTTParty.get("https://www.meethue.com/api/nupnp").first["internalipaddress"]
					unless HTTParty.get("http://#{@ip}/api/#{@user}/config").include?("whitelist")
						if HTTParty.post("http://#{@ip}/api", :body => ({:devicetype => "Hue_Switch", :username=>"1234567890"}).to_json).first.include?("error")
							raise "You need to press the link button on the bridge and run again"
						end
					end
				end
			end
			expect{SwitchTest.new}.to raise_error(RuntimeError)
		end
	end

	context "new Switch without parameters" do
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

		it "controls a single light" do
			lights = @switch.instance_variable_get(:@lights).keys
			@switch.light lights[rand(lights.length)].to_sym
			result = @switch.on.first
			expect {result.to respond_to(:to_i) }
		end
	end
end