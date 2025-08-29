page 81272 "API_Pending Purch Inv."
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiPendingPurchInv';
    DelayedInsert = true;
    EntityName = 'apiPendingPurchInv';
    EntityCaption = 'apiPendingPurchInv';
    EntitySetName = 'apiPendingPurchInvs';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiPendingPurchInvs';
    PageType = API;
    SourceTable = "Purch. Inv. Header";

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
                    ToolTip = 'Specifies the posted invoice number.';
                }
                field(buyFromVendorNo; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    Caption = 'Buy-from Vendor No.';
                    ToolTip = 'Specifies the identifier of the vendor that you bought the items from.';
                }
                field("documentDate"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    Caption = 'Document Date';
                    ToolTip = 'Specifies the date on which the purchase document was created.';
                }
                field("postingDate"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date';
                    ToolTip = 'Specifies the date the purchase header was posted.';
                }
                field(amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ToolTip = 'Specifies the total, in the currency of the invoice, of the amounts on all the invoice lines.';
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

        //T39004-NS NG 08092023
        IF Rec.GETFILTER("Buy-from Vendor No.") = '' THEN
            ERROR('Apply Vendor filter Require, (Referesh Browser and Login again)');
        //T39004-NE
    end;
}

