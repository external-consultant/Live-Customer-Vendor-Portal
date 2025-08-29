page 81281 "API_Proc_CusVendtInfo"    //"INT Web Portal - Statistics"  --> CusVendtInfo_gFnc
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiCusVendtInfo';
    DelayedInsert = true;
    EntityName = 'apiCusVendtInfo';
    EntityCaption = 'apiCusVendtInfo';
    EntitySetName = 'apiCusVendtInfos';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiCusVendtInfos';
    PageType = API;
    SourceTable = API_Post_Data;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(lcyCode_vCod; Rec.LCYCode_vCod)
                {
                    ApplicationArea = All;
                }
                field(companyName_vTxt; Rec.CompanyName_vTxt)
                {
                    ApplicationArea = All;
                }
                field(customerVenCode_iCod; Rec.CustomerVenCode_iCod)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        CompanyInformation_lRec: Record "Company Information";
        Customer_lRec: Record Customer;
        GeneralLedgerSetup_lRec: Record "General Ledger Setup";
        Vendor_lRec: Record Vendor;
    begin
        if Customer_lRec.Get(Rec.CustomerVenCode_iCod) then
            if Customer_lRec."Currency Code" <> '' then
                Rec.LCYCode_vCod := Customer_lRec."Currency Code"
            else begin
                GeneralLedgerSetup_lRec.Get();
                Rec.LCYCode_vCod := GeneralLedgerSetup_lRec."LCY Code";
            end;

        if Vendor_lRec.Get(Rec.CustomerVenCode_iCod) then
            if Vendor_lRec."Currency Code" <> '' then
                Rec.LCYCode_vCod := Vendor_lRec."Currency Code"
            else begin
                GeneralLedgerSetup_lRec.Get();
                Rec.LCYCode_vCod := GeneralLedgerSetup_lRec."LCY Code";
            end;

        CompanyInformation_lRec.Get();
        Rec.CompanyName_vTxt := COPYSTR(CompanyInformation_lRec.Name, 1, MaxStrLen(Rec.CompanyName_vTxt));
    end;

    trigger OnOpenPage()
    var
        INTKeyValidationMgt: Codeunit "IKV Mgt";
    begin
        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();
    end;

}

