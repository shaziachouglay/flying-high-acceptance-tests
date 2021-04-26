Feature: Earning Points

  Frequent Flyers earn status points each time they fly.
  As they earn more points, their status level increases and they get more benefits.
  For example:

  @journey-scenario
  @current
  Example: Stan goes from Standard to Silver after he makes several trips
    Given Stan has logged onto the Frequent Flyer application as a new member
    When he books the following flights:
      | From   | To          | Travel Class | Trip Type | Notes           |
      | London | New York    | Business     | Return    |                 |
      | London | Los Angeles | Business     | Return    | Gets to BRONZE  |
      | Sydney | Hong Kong   | Economy      | Single    | Earns 25% extra |
    Then his booking history should contain:
      | Departure   | Destination | Points Earned |
      | London      | New York    | 250           |
      | New York    | London      | 250           |
      | London      | Los Angeles | 250           |
      | Los Angeles | London      | 250           |
      | Sydney      | Hong Kong   | 125           |
    And his account status should become:
      | Point Balance | Status Level |
      | 1125          | BRONZE       |

  Rule: Members achieve new status levels when they earn sufficient points
    Scenario Outline: Earning status levels from points earned for status level <Status Level>
      Given Stan is a new Frequent Flyer Member
      When he earns between <Min Points> and <Max Points> points
      Then his status should become <Status Level>
      Examples:
        | Min Points | Max Points | Status Level |
        | 0          | 999        | STANDARD     |
        | 1000       | 1999       | BRONZE       |
        | 2000       | 4999       | SILVER       |
        | 5000       |            | GOLD         |

  Rule: Cities are located in one of four regions for the purposes of point calculations
  The four regions are:
  - Europe
  - Americas
  - Australia/New Zealand (ANZ)
  - Asia

    Scenario Outline: The region for <City> should be <Region>
      When points are calculated for a flight to or from <City>
      Then the city should be considered to be part of the <Region Code> region
      Examples:
        | City         | Region                | Region Code |
        | London       | Europe                | EUR         |
        | Sydney       | Australia/New Zealand | ANZ         |
        | Los Angeles  | America               | AMERICA     |
        | Buenos Aires | America               | AMERICA     |
        | Seoul        | Asia                  | ASIA        |


  Rule: Base points are calculated based on the distance between regions
    Background:
      Given Stan has logged onto the Frequent Flyer application as a new member

    Example: Stan books a single economy flight from London to Sydney
      When Stan books a single Economy flight from London to Sydney
      Then his point balance should be 250 points

    Example: Stan books a return economy flight from London to Sydney
      When Stan books a return Economy flight from London to Sydney
      Then his point balance should be 500 points

  Rule: Flights within the same region earn a fixed number of points based
    Scenario Outline: Flights within the <Region> region earn <Points Earned> points
      Given Trevor has logged onto the Frequent Flyer application as a new member
      When he books an Economy flight from <From> to <To>
      Then he should earn <Points Earned> points

      Examples:
        | Region  | From        | To         | Points Earned |
        | Europe  | London      | Paris      | 20            |
        | ANZ     | Sydney      | Wellington | 25            |
        | America | Los Angeles | New York   | 35            |
        | Asia    | Hong Kong   | Seoul      | 50            |

  Rule: Travellers with higher status earn more points
    Scenario Outline: Travellers with <Status> level should earn <Bonus> bonus points
    A flight from Sydney to Hong Kong normally earns 100 points

      Given Tracy is a Frequent Flyer Member with status <Status>
      And she has logged onto the Frequent Flyer application
      When she books an Economy flight from Sydney to Hong Kong
      Then she should earn <Points Earned> points

      Examples:
        | Status   | Points Earned | Bonus |
        | STANDARD | 100           | 0     |
        | BRONZE   | 125           | 25%   |
        | SILVER   | 150           | 50%   |
        | GOLD     | 200           | 100%  |

  Rule: Travellers earn more depending on the cabin class they fly in
    Scenario Outline: Travellers travelling in <Travel Class> class should earn <Bonus> bonus points
    A flight from Sydney to Hong Kong normally earns 100 points

      Given Tracy has logged onto the Frequent Flyer application as a new member
      When he books an <Travel Class> flight from Sydney to Hong Kong
      Then he should earn <Points Earned> points

      Examples:
        | Travel Class    | Points Earned | Bonus |
        | Economy         | 100           | 0     |
        | Premium Economy | 150           | 50%   |
        | Business        | 200           | 100%  |