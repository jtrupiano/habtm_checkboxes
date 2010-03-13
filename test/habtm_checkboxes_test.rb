require 'test_helper'
require "active_support"
require "action_controller"
require 'action_view/helpers'
require 'habtm_checkboxes'

# Mock objects
module HabtmCheckboxes
  #   habtm_checkboxes(@organizer, :event_ids, @events, :name)
  #
  #   <%= hidden_field_tag "organizer[event_ids][]", "" %>
  #   <% @events.each do |event| -%>
  #     <%= check_box_tag "organizer[event_ids][]", event.id, @organizer.event_ids.include?(event.id), :id => "organizer_events_id_#{event.id}" %>
  #     <%= label_tag "organizer_events_id_#{event.id}", h(event.name) %>
  #   <% end -%>
  
  class Organizer
    def event_ids
      [1]
    end
  end
  
  class Event
    attr_reader :id, :name
    def initialize(id, name)
      @id, @name = id, name
    end
  end
end

class HabtmCheckboxesTest < ActionController::TestCase
  include ActionView::Helpers
  include HabtmCheckboxes

  test "With 2 events and an organizer, all 5 elements are correctly generated and wired up" do
    organizer = Organizer.new
    events = [Event.new(1, "One"), Event.new(2, "Two")]
    html = habtm_checkboxes(organizer, :event_ids, events, :name)

    doc = HTML::Document.new html
    assert_select doc.root, 'input', :type => 'hidden', :name => 'organizer[event_ids][]'
    assert_select doc.root, 'input', :id => 'organizer_events_id_1'
    assert_select doc.root, 'label', :for => 'organizer_events_id_1'
    assert_select doc.root, 'input', :type => 'checkbox', :id => 'organizer_events_id_2'
    assert_select doc.root, 'label', :for => 'organizer_events_id_2'
  end
end
