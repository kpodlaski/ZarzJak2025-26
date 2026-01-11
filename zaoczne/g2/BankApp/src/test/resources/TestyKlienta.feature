Feature: MoneyTransfer tests, account is not mocked

  Background:
    Given Setup environments with mocks

  Scenario: Internal payment, all is ok
    Given We have user "Tomasz" with id: 1
    Given "Tomasz" have account: 2 with: 1000 pln
    Given There is an account:3 with 100 pln
    Given Everything is authorised
    Given DataBase is working properly
    When "Tomasz" make transfer from acc: 2 to acc: 3 with amount: 200
    Then account:2 value:800.0 pln
    Then account:3 value:300.0 pln
    Then All operations were successful

#  Scenario Outline: Proper Internal money flows
#    Given We have user "<user>" with id: 1
#    Given "<user>" have account: <srcAcc> with: <srcAmount> pln
#    Given There is an account:<dstAcc> with <dstAmount> pln
#    Given Everything is authorised
#    #Given DAO works in a proper way
#    When "<user>" make transfer from acc: <srcAcc> to acc: <dstAcc> with amount: <amount>
#    Then account:<srcAcc> value:<expSrc> pln
#    Then account:<dstAcc> value:<expDst> pln
#    ## TODO
#    Then All operations were successful
#    #Then Expect updates only on proper accounts
#      # |<srcAcc>|<dstAcc>|
#    #Then Withdraw was logged properly
#    #Then Payment was logged properly
#
#    Examples:
#      |user   |srcAcc |srcAmount  |dstAcc |dstAmount  |amount |expSrc |expDst |
#      |Tomasz |1      |200        |2      |100        |158.2  |41.8   |258.2  |
#      |Tomasz |1      |200        |3      |100        |200    |0      |300    |
#      |Alicja |3      |1000       |1      |0          |100    |900    |100    |
#
###### Przykłady scenariuszy do aplikacji
#
#    Scenario Outline: Operate with wrong ammount
#        Given We have user "<user>"
#        Given "<user>" have account: <srcAcc> with: <srcAmount> pln
#        Given There is an account:<dstAcc> with <dstAmount> pln
#        Given All database operations are sucessfull
#        Given All "<user>" operations are allowed
#        When "<user>" make transfer from acc: <srcAcc> to acc: <dstAcc> with amount: <amount>
#        Then account:<srcAcc> value:<srcAmount> pln
#        Then account:<dstAcc> value:<dstAmount> pln
#        Then Operation is unsuccessful
#        Then No updates on accounts
#        #Then Withdraw was logged properly
#        #Then Payment was logged properly
#
#        Examples:
#            |user   |srcAcc |srcAmount  |dstAcc |dstAmount  |amount|
#            |Tomasz |1      |200        |2      |100        |-158.2|
#            |Tomasz |1      |200        |3      |100        |201   |
#            |Tomasz |1      |200        |3      |100        |0     |
#            |Tomasz |1      |200        |3      |100        |0.0   |
#
#    Scenario Outline: User is not authorize to withdraw
#        Given We have user with name "<user1>"
#        Given "<user2>" has account number: <srcAcc> with amount: <srcAmount>
#        Given We have account number: <dstAcc> with amount: <dstAmount>
#        Given All database operations are sucessfull
#        Given Users can operate on own accounts only
#        When "<user1>" make internal payment from acc: <srcAcc> to acc: <dstAcc> amount <amount>
#        Then Account <srcAcc> have <srcAmount>
#        Then Account <dstAcc> have <dstAmount>
#        Then Operation is unsuccessful
#        Then No updates on accounts
#        Then Operation was not authorized
#        Then Unauthorized operation was logged properly
#
#
#        Examples:
#            |user1  |srcAcc |srcAmount  |dstAcc |dstAmount  |amount|user2 |
#            |Tomasz |1      |200        |2      |100        |158.2|Maria |
#
#    Scenario Outline: User is not authorize to withdraw from destination account
#        Given "<user1>" has account number: <srcAcc> with amount: <srcAmount>
#        Given "<user2>" has account number: <dstAcc> with amount: <datAmount>
#        Given All database operations are sucessfull
#        Given Users can operate on own accounts only
#        When "<user1>" make internal payment from acc: <srcAcc> to acc: <dstAcc> amount <amount>
#        Then Account <srcAcc> have <srcAmount>
#        Then Account <dstAcc> have <dstAmount>
#        Then Operation is successful
#        Then Expect updates only on proper accounts
#            |<srcAcc>|<dstAcc>|
#        Then Withdraw was logged properly
#        Then Payment was logged properly
#
#
#        Examples:
#            |user1  |srcAcc |srcAmount  |dstAcc |dstAmount  |amount |user2 |expSrc  |expDst |
#            |Tomasz |1      |200        |2      |100        |101.2  |Maria |98.8    |201.2  |
#
#    Scenario: Database malfunction
#        Given "<user1>" has account number: <srcAcc> with amount: <srcAmount>
#        Given "<user2>" has account number: <dstAcc> with amount: <datAmount>
#        Given All database operations are unsucessfull
#        Given Users can operate on own accounts only
#        When "<user1>" make internal payment from acc: <srcAcc> to acc: <dstAcc> amount <amount>
#    #DB falied so no sense to ask for account states
#    #Then Account <srcAcc> have <srcAmount>
#    #Then Account <dstAcc> have <dstAmount>
#        Then Operation is unsuccessful
#        Then Expect updates only on proper accounts
#            |<srcAcc>|<dstAcc>|
#        Then Error was logged properly
#        Then "EXCEPTION" ??