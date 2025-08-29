page 81262 "API_Web Portal-Posted Invoice"
{
    // version WebPortal

    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiWebPortalPostedInvoice';
    DelayedInsert = true;
    EntityName = 'apiWebPortalPostedInvoice';
    EntityCaption = 'apiWebPortalPostedInvoice';
    EntitySetName = 'apiWebPortalPostedInvoices';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiWebPortalPostedInvoices';
    PageType = API;
    SourceTable = "Sales Invoice Header";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(no; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                    ToolTip = 'Specifies the number of the record.';
                }
                field(postingDate; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date';
                    ToolTip = 'Specifies the date on which the invoice was posted.';
                }
                field(selltoCustomerNo; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    Caption = 'Sell-to Customer No.';
                    ToolTip = 'Specifies the number of the customer the invoice concerns.';
                }
                field(selltoCustomerName; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    Caption = 'Sell-to Customer Name';
                    ToolTip = 'Specifies the customer''s name.';
                }
                field(shiptoCode; Rec."Ship-to Code")
                {
                    ApplicationArea = All;
                    Caption = 'Ship-to Code';
                    ToolTip = 'Specifies the address on purchase orders shipped with a drop shipment directly from the vendor to a customer.';
                }
                field(shiptoName; Rec."Ship-to Name")
                {
                    ApplicationArea = All;
                    Caption = 'Ship-to Name';
                    ToolTip = 'Specifies the name of the customer that the items were shipped to.';
                }
                field(amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ToolTip = 'Specifies the total amount on the sales invoice excluding VAT.';
                }
                field(amountIncludingVAT; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Amount Including VAT';
                    ToolTip = 'Specifies the total amount on the sales invoice including VAT.';
                }
                field(recordCount; RecCnt_gInt)
                {
                    ApplicationArea = All;
                    Caption = 'Record Count';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Record Count field.';
                }
                field(externalDocNo_gCod; ExternalDocNo_gCod)
                {
                    ApplicationArea = All;
                    Caption = 'ExternalDocNo_gCod';
                    ToolTip = 'Specifies the value of the ExternalDocNo_gCod field.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        SaleInvsHdr_lRec: Record "Sales Invoice Header";
    begin
        RecCnt_gInt += 1;

        ExternalDocNo_gCod := '';
        Clear(SaleInvsHdr_lRec);
        if SaleInvsHdr_lRec.Get(Rec."No.") then
            ExternalDocNo_gCod := SaleInvsHdr_lRec."External Document No.";
    end;

    trigger OnOpenPage()
    var
        INTKeyValidationMgt: Codeunit "IKV Mgt";
    begin
        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();

        //T39004-NS NG 08092023
        IF Rec.GETFILTER("Sell-to Customer No.") = '' THEN
            ERROR('Apply Customer filter Require, (Referesh Browser and Login again)');
        //T39004-NE
    end;

    var
        ExternalDocNo_gCod: Code[35];
        RecCnt_gInt: Integer;
}

