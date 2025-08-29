page 81275 "API_Proc_InsertCheckData"   // "INT Web Portal - Check Mgmt" --> InsertCheckData_gFnc
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiWebPortalProcInsertCheckData';
    DelayedInsert = true;
    EntityName = 'apiWebPortalProcInsertCheckData';
    EntityCaption = 'apiWebPortalProcInsertCheckData';
    EntitySetName = 'apiWebPortalProcInsertCheckDatas';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiWebPortalProcInsertCheckDatas';
    PageType = API;
    SourceTable = API_Post_Data;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(loginTypeiTxt; Rec.LoginType_iTxt)
                {
                    ApplicationArea = all;
                }
                field(accNoiCod; Rec.AccNo_iCod)
                {
                    ApplicationArea = all;
                }
                field(paymentTypeiTxt; Rec.PaymentType_iTxt)
                {
                    ApplicationArea = all;
                }
                field(checkNoiTxt; Rec.CheckNo_iTxt)
                {
                    ApplicationArea = all;
                }
                field(checkDateiDte; Rec.CheckDate_iDte)
                {
                    ApplicationArea = all;
                }
                field(checkIssueByiTxt; Rec.CheckIssueBy_iTxt)
                {
                    ApplicationArea = all;
                }
                field(checkReceivedByiTxt; Rec.CheckReceivedBy_iTxt)
                {
                    ApplicationArea = all;
                }
                field(bankNameiTxt; Rec.BankName_iTxt)
                {
                    ApplicationArea = all;
                }
                field(bankBranchNameiTxt; Rec.BankBranchName_iTxt)
                {
                    ApplicationArea = all;
                }
                field(neftRTGSRefNoiTxt; Rec.NEFT_RTGSRefNo_iTxt)
                {
                    ApplicationArea = all;
                }
                field(amountiDec; Rec.Amount_iDec)
                {
                    ApplicationArea = all;
                }
                field(Result_gBln; Rec.Result_gBln)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        Customer_lRec: Record Customer;
        CheckInfo_lRec: Record "INT -Check Information";
        Vendor_lRec: Record Vendor;
        PaymentType_lOpt: Option " ",Check,NEFT,RTGS,CASH;
        LoginType_lOpt: Option " ",Customer,Vendor;
    begin
        //Login Type
        if not (Rec.LoginType_iTxt in ['Customer', 'Vendor']) then
            Error('Login Type should be either Customer or Vendor');

        //Account No.
        if Rec.AccNo_iCod = '' then
            Error('Account No. must have a value.');

        if not (Rec.PaymentType_iTxt in ['Check', 'NEFT', 'RTGS', 'CASH']) then
            Error('Payment Type should be either Check/NEFT/RTGS/CASH');

        Evaluate(LoginType_lOpt, Rec.LoginType_iTxt);
        Evaluate(PaymentType_lOpt, Rec.PaymentType_iTxt);

        if LoginType_lOpt = LoginType_lOpt::Customer then begin
            Clear(Customer_lRec);
            if not Customer_lRec.Get(Rec.AccNo_iCod) then
                Error('Customer %1 does not exist.', Rec.AccNo_iCod);
        end else begin
            Clear(Vendor_lRec);
            if not Vendor_lRec.Get(Rec.AccNo_iCod) then
                Error('Vendor %1 does not exist.', Rec.AccNo_iCod);
        end;

        case PaymentType_lOpt of
            PaymentType_lOpt::Check:
                begin
                    if Rec.CheckNo_iTxt = '' then
                        Error('Check No cannot be blank.');
                    if Rec.CheckDate_iDte = 0D then
                        Error('Check Date cannot be blank.');
                    if Rec.BankName_iTxt = '' then
                        Error('Bank Name cannot be blank.');
                    if Rec.BankBranchName_iTxt = '' then
                        Error('Bank Branch Name cannot be blank.');
                    if Rec.Amount_iDec = 0 then
                        Error('Amount cannot be blank');
                end;
            PaymentType_lOpt::CASH:
                if Rec.Amount_iDec = 0 then
                    Error('Amount cannot be blank');
            PaymentType_lOpt::NEFT,
            PaymentType_lOpt::RTGS:
                begin
                    if Rec.NEFT_RTGSRefNo_iTxt = '' then
                        Error('NEFT/RTGS Reference No. cannot be blank');
                    if Rec.BankName_iTxt = '' then
                        Error('Bank Name cannot be blank.');
                    if Rec.Amount_iDec = 0 then
                        Error('Amount cannot be blank');
                end;
        end;

        CheckInfo_lRec.Reset();
        CheckInfo_lRec.Init();
        CheckInfo_lRec.Validate("Login Type", LoginType_lOpt);
        CheckInfo_lRec.Validate("Account No.", Rec.AccNo_iCod);
        CheckInfo_lRec.Validate("Payment Type", PaymentType_lOpt);
        CheckInfo_lRec.Validate("Check No.", Rec.CheckNo_iTxt);
        CheckInfo_lRec.Validate("Check Date", Rec.CheckDate_iDte);
        CheckInfo_lRec.Validate("Check Issue By", Rec.CheckIssueBy_iTxt);
        CheckInfo_lRec.Validate("Check Received By", Rec.CheckReceivedBy_iTxt);
        CheckInfo_lRec.Validate("Bank Name", Rec.BankName_iTxt);
        CheckInfo_lRec.Validate("Bank Branch Name", Rec.BankBranchName_iTxt);
        CheckInfo_lRec.Validate("NEFT/RTGS Reference No.", Rec.NEFT_RTGSRefNo_iTxt);
        CheckInfo_lRec.Validate(Amount, Rec.Amount_iDec);
        CheckInfo_lRec.Insert(true);

        Rec.Result_gBln := TRUE;
    end;

    trigger OnOpenPage()
    var
        INTKeyValidationMgt: Codeunit "IKV Mgt";
    begin
        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();
    end;

    Var
        LoginType_iTxt: Text[50];
        AccNo_iCod: Code[20];
        PaymentType_iTxt: Text[50];
        CheckNo_iTxt: Text[30];
        CheckDate_iDte: Date;
        CheckIssueBy_iTxt: Text[50];
        CheckReceivedBy_iTxt: Text[50];
        BankName_iTxt: Text[50];
        BankBranchName_iTxt: Text[50];
        NEFT_RTGSRefNo_iTxt: Text[50];
        Amount_iDec: Decimal;
}