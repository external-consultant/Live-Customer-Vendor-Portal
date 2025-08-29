page 81271 "API_Pending Sales Inv."
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiPendingSalesInv';
    DelayedInsert = true;
    EntityName = 'apiPendingSalesInv';
    EntityCaption = 'apiPendingSalesInv';
    EntitySetName = 'apiPendingSalesInvs';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiPendingSalesInvs';
    PageType = API;
    SourceTable = "Sales Header";

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
                    ToolTip = 'Specifies the number of the estimate.';
                }
                field(billtoCustomerNo; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = All;
                    Caption = 'Bill-to Customer No.';
                    ToolTip = 'Specifies the number of the customer that you send or sent the invoice or credit memo to.';
                }
                field(externalDocumentNo; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'External Document No.';
                    ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
                }
                field(documentDate; Rec."Document Date")
                {
                    ApplicationArea = All;
                    Caption = 'Document Date';
                    ToolTip = 'Specifies when the sales invoice was created.';
                }
                field(postingDate; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date';
                    ToolTip = 'Specifies the date when the posting of the sales document will be recorded.';
                }
                field(amounttoCustomer; Round(Rec."Amount Including VAT", 1))
                {
                    ApplicationArea = All;
                    Caption = 'Amount to Customer';
                    ToolTip = 'Specifies the value of the Amount to Customer field.';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        INTKeyValidationMgt: Codeunit "IKV Mgt";
    begin
        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();
        Rec.SetCurrentKey("Posting Date");
        Rec.Ascending(false);

        //T39004-NS NG 08092023
        IF Rec.GETFILTER("Bill-to Customer No.") = '' THEN
            ERROR('Apply Customer filter Require, (Referesh Browser and Login again)');
        //T39004-NE
    end;
}

