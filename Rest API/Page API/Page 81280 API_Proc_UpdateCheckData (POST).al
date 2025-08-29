page 81280 "API_Proc_UpdateCheckData"   // "INT Web Portal - Check Mgmt" --> UpdateCheckData_gFnc
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiWebPortalProcUpdateCheckData';
    DelayedInsert = true;
    EntityName = 'apiWebPortalProcUpdateCheckData';
    EntityCaption = 'apiWebPortalProcUpdateCheckData';
    EntitySetName = 'apiWebPortalProcUpdateCheckDatas';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiWebPortalProcUpdateCheckDatas';
    PageType = API;
    SourceTable = API_Post_Data;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(entryNoiInt; Rec.EntryNo_iInt)
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
        CheckInfo_lRec: Record "INT -Check Information";
    begin
        if not CheckInfo_lRec.Get(Rec.EntryNo_iInt) then
            Error('There is no Information for Entry NO %1 in the system', Rec.EntryNo_iInt);

        if Rec.CheckNo_iTxt <> '' then
            CheckInfo_lRec.Validate("Check No.", Rec.CheckNo_iTxt);

        if Rec.CheckDate_iDte <> 0D then
            CheckInfo_lRec.Validate("Check Date", Rec.CheckDate_iDte);

        if Rec.CheckIssueBy_iTxt <> '' then
            CheckInfo_lRec.Validate("Check Issue By", Rec.CheckIssueBy_iTxt);

        if Rec.CheckReceivedBy_iTxt <> '' then
            CheckInfo_lRec.Validate("Check Received By", Rec.CheckReceivedBy_iTxt);

        if Rec.BankName_iTxt <> '' then
            CheckInfo_lRec.Validate("Bank Name", Rec.BankName_iTxt);

        if Rec.BankBranchName_iTxt <> '' then
            CheckInfo_lRec.Validate("Bank Branch Name", Rec.BankBranchName_iTxt);

        if Rec.NEFT_RTGSRefNo_iTxt <> '' then
            CheckInfo_lRec.Validate("NEFT/RTGS Reference No.", Rec.NEFT_RTGSRefNo_iTxt);

        if Rec.Amount_iDec <> 0 then
            CheckInfo_lRec.Validate(Amount, Rec.Amount_iDec);

        CheckInfo_lRec.Modify(true);
        Rec.Result_gBln := true;
    end;

    trigger OnOpenPage()
    var
        INTKeyValidationMgt: Codeunit "IKV Mgt";
    begin
        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();
    end;
}
