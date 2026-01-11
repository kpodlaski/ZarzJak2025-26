package biz;

import db.dao.DAO;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import model.Account;
import model.User;
import model.exceptions.OperationIsNotAllowedException;
import org.mockito.Mockito;

import java.lang.reflect.Field;
import java.sql.SQLException;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

public class MoneyTransferSteps {
    AccountManager target;
    DAO daoMock;
    AuthenticationManager authMock;
    BankHistory histMock;
    InterestOperator interestMock;
    boolean result;


    @Given("Setup environments with mocks")
    public void setup_environments_with_mocks() throws NoSuchFieldException, IllegalAccessException {
        target = new AccountManager();
        daoMock = Mockito.mock(DAO.class);
        authMock = Mockito.mock(AuthenticationManager.class);
        histMock = Mockito.mock(BankHistory.class);
        interestMock = Mockito.mock(InterestOperator.class);
        target.dao = daoMock;
        target.auth = authMock;
        target.history = histMock;
        //for private field
        //target.interestOperator = interestMock;
        Field interestField = target.getClass().getDeclaredField("interestOperator");
        interestField.setAccessible(true);
        interestField.set(target,interestMock);
    }
    //Given We have user "Tomasz" with id: 1
    @Given("We have user {string} with id: {int}")
    public void we_have_user_with_id(String name, Integer id) throws SQLException {
        User u = new User();
        u.setName(name);
        u.setId(id);
        when(daoMock.findUserByName(name)).thenReturn(u);
    }

    @Given("{string} have account: {int} with: {double} pln")
    public void have_account_with_pln(String name, Integer accid, Double amount) throws SQLException {
        User u = daoMock.findUserByName(name);
        Account acc = new Account();
        acc.setOwner(u);
        acc.setId(accid);
        acc.setAmmount(amount);
        when(daoMock.findAccountById(accid)).thenReturn(acc);
    }

    @Given("There is an account:{int} with {double} pln")
    public void there_is_an_account_with_pln(Integer accid, Double amount) throws SQLException {
        Account acc = new Account();
        acc.setId(accid);
        acc.setAmmount(amount);
        when(daoMock.findAccountById(accid)).thenReturn(acc);
    }
    @Given("Everything is authorised")
    public void everything_is_authorised() {
        when(authMock.canInvokeOperation(any(), any())).thenReturn(true);
    }

    @Given("DataBase is working properly")
    public void database_is_working() throws SQLException {
        when(daoMock.updateAccountState(any())).thenReturn(true);

    }

    @When("{string} make transfer from acc: {int} to acc: {int} with amount: {double}")
    public void make_transfer_from_acc_to_acc_with_amount(String name,
              Integer srcId, Integer dstId, Double amount) throws SQLException, OperationIsNotAllowedException {
        User u = daoMock.findUserByName(name);
        result = target.internalPayment(u,amount," ", srcId, dstId );
    }

    @Then("account:{int} value:{double} pln")
    public void account_value_pln(Integer accid, Double amount) throws SQLException {
        // Write code here that turns the phrase above into concrete actions
        Account acc = daoMock.findAccountById(accid);
        assertEquals(amount,acc.getAmmount(), 0.01);
    }
    @Then("All operations were successful")
    public void all_operations_were_successful() {
        assertTrue(result);
    }
}
