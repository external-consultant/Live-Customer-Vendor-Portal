codeunit 81238 "INT Web Portal - Check Mgmt"
{
    // version WebPortal


    trigger OnRun()
    begin
        //InsertCheckData_gFnc('Customer','C001145','NEFT','',121216D,'IssuerName','ReceiverName','Yes Bank','Ahmedabad','123456',15000);
        //UpdateCheckData_gFnc(1,'123456',121216D,'IssuerName','ReceiverName','Axis','Maninagar','55225522',25000);
    end;

    procedure InsertCheckData_gFnc(LoginType_iTxt: Text[50]; AccNo_iCod: Code[20]; PaymentType_iTxt: Text[50]; CheckNo_iTxt: Text[30]; CheckDate_iDte: Date; CheckIssueBy_iTxt: Text[50]; CheckReceivedBy_iTxt: Text[50]; BankName_iTxt: Text[50]; BankBranchName_iTxt: Text[50]; NEFT_RTGSRefNo_iTxt: Text[50]; Amount_iDec: Decimal): Boolean
    var
        Customer_lRec: Record Customer;
        CheckInfo_lRec: Record "INT -Check Information";
        Vendor_lRec: Record Vendor;
        PaymentType_lOpt: Option " ",Check,NEFT,RTGS,CASH;
        LoginType_lOpt: Option " ",Customer,Vendor;
    begin
        //Login Type
        if not (LoginType_iTxt in ['Customer', 'Vendor']) then
            Error('Login Type should be either Customer or Vendor');

        //Account No.
        if AccNo_iCod = '' then
            Error('Account No. must have a value.');

        if not (PaymentType_iTxt in ['Check', 'NEFT', 'RTGS', 'CASH']) then
            Error('Payment Type should be either Check/NEFT/RTGS/CASH');

        Evaluate(LoginType_lOpt, LoginType_iTxt);
        Evaluate(PaymentType_lOpt, PaymentType_iTxt);

        if LoginType_lOpt = LoginType_lOpt::Customer then begin
            Clear(Customer_lRec);
            if not Customer_lRec.Get(AccNo_iCod) then
                Error('Customer %1 does not exist.', AccNo_iCod);
        end else begin
            Clear(Vendor_lRec);
            if not Vendor_lRec.Get(AccNo_iCod) then
                Error('Vendor %1 does not exist.', AccNo_iCod);
        end;

        case PaymentType_lOpt of
            PaymentType_lOpt::Check:
                begin
                    if CheckNo_iTxt = '' then
                        Error('Check No cannot be blank.');
                    if CheckDate_iDte = 0D then
                        Error('Check Date cannot be blank.');
                    if BankName_iTxt = '' then
                        Error('Bank Name cannot be blank.');
                    if BankBranchName_iTxt = '' then
                        Error('Bank Branch Name cannot be blank.');
                    if Amount_iDec = 0 then
                        Error('Amount cannot be blank');
                end;
            PaymentType_lOpt::CASH:
                if Amount_iDec = 0 then
                    Error('Amount cannot be blank');
            PaymentType_lOpt::NEFT,
            PaymentType_lOpt::RTGS:
                begin
                    if NEFT_RTGSRefNo_iTxt = '' then
                        Error('NEFT/RTGS Reference No. cannot be blank');
                    if BankName_iTxt = '' then
                        Error('Bank Name cannot be blank.');
                    if Amount_iDec = 0 then
                        Error('Amount cannot be blank');
                end;
        end;

        CheckInfo_lRec.Reset();
        CheckInfo_lRec.Init();
        CheckInfo_lRec.Validate("Login Type", LoginType_lOpt);
        CheckInfo_lRec.Validate("Account No.", AccNo_iCod);
        CheckInfo_lRec.Validate("Payment Type", PaymentType_lOpt);
        CheckInfo_lRec.Validate("Check No.", CheckNo_iTxt);
        CheckInfo_lRec.Validate("Check Date", CheckDate_iDte);
        CheckInfo_lRec.Validate("Check Issue By", CheckIssueBy_iTxt);
        CheckInfo_lRec.Validate("Check Received By", CheckReceivedBy_iTxt);
        CheckInfo_lRec.Validate("Bank Name", BankName_iTxt);
        CheckInfo_lRec.Validate("Bank Branch Name", BankBranchName_iTxt);
        CheckInfo_lRec.Validate("NEFT/RTGS Reference No.", NEFT_RTGSRefNo_iTxt);
        CheckInfo_lRec.Validate(Amount, Amount_iDec);
        CheckInfo_lRec.Insert(true);

        exit(true);
    end;

    procedure UpdateCheckData_gFnc(EntryNo_iInt: Integer; CheckNo_iTxt: Text[30]; CheckDate_iDte: Date; CheckIssueBy_iTxt: Text[50]; CheckReceivedBy_iTxt: Text[50]; BankName_iTxt: Text[50]; BankBranchName_iTxt: Text[50]; NEFT_RTGSRefNo_iTxt: Text[50]; Amount_iDec: Decimal): Boolean
    var
        CheckInfo_lRec: Record "INT -Check Information";
    begin
        if not CheckInfo_lRec.Get(EntryNo_iInt) then
            Error('There is no Information for Entry NO %1 in the system', EntryNo_iInt);

        if CheckNo_iTxt <> '' then
            CheckInfo_lRec.Validate("Check No.", CheckNo_iTxt);

        if CheckDate_iDte <> 0D then
            CheckInfo_lRec.Validate("Check Date", CheckDate_iDte);

        if CheckIssueBy_iTxt <> '' then
            CheckInfo_lRec.Validate("Check Issue By", CheckIssueBy_iTxt);

        if CheckReceivedBy_iTxt <> '' then
            CheckInfo_lRec.Validate("Check Received By", CheckReceivedBy_iTxt);

        if BankName_iTxt <> '' then
            CheckInfo_lRec.Validate("Bank Name", BankName_iTxt);

        if BankBranchName_iTxt <> '' then
            CheckInfo_lRec.Validate("Bank Branch Name", BankBranchName_iTxt);

        if NEFT_RTGSRefNo_iTxt <> '' then
            CheckInfo_lRec.Validate("NEFT/RTGS Reference No.", NEFT_RTGSRefNo_iTxt);

        if Amount_iDec <> 0 then
            CheckInfo_lRec.Validate(Amount, Amount_iDec);

        CheckInfo_lRec.Modify(true);
        exit(true);
    end;
}

