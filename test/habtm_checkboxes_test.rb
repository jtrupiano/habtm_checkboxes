require 'test_helper'
require 'action_controller'
require 'action_view/helpers'
require 'habtm_checkboxes'

# Mock objects
module HabtmCheckboxes
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
    assert_select doc.root, 'input#organizer_event_ids_1', :type => 'checkbox'
    assert_select doc.root, 'label[for=organizer_event_ids_1]'
    assert_select doc.root, 'input#organizer_event_ids_2', :type => 'checkbox'
    assert_select doc.root, 'label[for=organizer_event_ids_2]'
    # Sanity check
    assert_select doc.root, 'label[for=organizer_event_ids_3]', :count => 0
    assert_select doc.root, 'input#organizer_event_ids_3', :count => 0
  end
end

