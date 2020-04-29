# This file is part of Moodle - http://moodle.org/
#
# Moodle is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Moodle is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Moodle.  If not, see <http://www.gnu.org/licenses/>.
#
# Tests for navigation between activities with restrictions.
#
# @package    theme_snap
# @author     Diego Casas <diego.casas@blackboard.com>
# @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later

@theme @theme_snap
Feature: When the moodle theme is set to Snap course pages can be rendered using lazy loading.
  Background:
    Given the following "courses" exist:
      | fullname | shortname |
      | Course 1 | C1 |
    Given the following "users" exist:
      | username  | firstname  | lastname  | email                 |
      | teacher1  | Teacher    | 1         | teacher1@example.com  |
      | student1  | Student    | 1         | student1@example.com  |

    And the following "course enrolments" exist:
      | user      | course  | role            |
      | student1  | C1      | student         |
      | teacher1  | C1      | editingteacher  |
      | admin     | C1      | editingteacher  |

    And I log in as "admin"
    And I am on "Course 1" course homepage with editing mode on
    And I add a "Page" to section "1" and I fill the form with:
      | Name         | Test Page        |
      | Description  | Test description |
      | Page content | <p>Test Content</p><img src="https://download.moodle.org/unittest/test.jpg" alt="test image" width="200" height="150" class="img-responsive atto_image_button_text-bottom"> |
    And I log out

  @javascript
  Scenario Outline: Check if Page content is being lazy loaded
    Given the following config values are set as admin:
      | lazyload_mod_page | <lazyload> | theme_snap |
    And I log in as "teacher1"
    And I am on the course "C1"
    And I follow "Topic 1"
    And I should see "Test Page"
    And ".pagemod-content" "css_element" should exist
    And "<class>" "css_element" should exist
    Examples:
      | lazyload | class                                       |
      | 0        | .pagemod-content[data-content-loaded=\"1\"] |
      | 1        | .pagemod-content[data-content-loaded=\"0\"] |