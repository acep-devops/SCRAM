Feature: an automated source adds a block entry
  Automated clients (eg zeek) can add v4/v6 block entries

  Scenario: unauthenticated users get a 403
    When we add the entry 127.0.0.1
    Then we get a 403 status code

  Scenario Outline: add a block entry
    Given a block actiontype is defined
    When we're logged in
    And  we add the entry <ip>
    And  we list the entrys

    Then the number of entrys is 1
    And  <cidr> is one of our list of entrys
    And  <ip> is contained in our entrys


    Examples: v4 IPs
      | ip          | cidr           |
      | 1.2.3.4     | 1.2.3.4/32     |
      | 193.168.0.0 | 193.168.0.0/32 |

    Examples: v6 IPs
      | ip     | cidr       |
      | 2000:: | 2000::/128 |
      | ::1    | ::1/128    |

  Scenario Outline: add a block entry multiple times and it's accepted
    Given a block actiontype is defined
    When we're logged in
    And  we add the entry <ip>
    And  we add the entry <ip>

    Then we get a 201 status code
    And the number of entrys is 1

    Examples: IPs
      | ip          |
      | 1.2.3.4     |
      | 193.168.0.0 |
      | 2000::      |
      | ::1         |

  Scenario Outline: invalid block entries can't be added
    Given a block actiontype is defined
    When we're logged in
    And  we add the entry <ip>

    Then we get a 400 status code
    And the number of entrys is 0

    Examples: invalid IPs
      | ip          |
      | 1.2.3.4/128 |
      | 256.0.0.0   |
      | 1.2         |
      | gg::        |
      | 1:          |
      | 2000::1::1  |
      | 2000::/129  |
