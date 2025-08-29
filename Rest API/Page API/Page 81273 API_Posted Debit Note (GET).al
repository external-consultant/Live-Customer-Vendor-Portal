page 81273 "API_Posted Debit Note"
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiPostedDebitNote';
    DelayedInsert = true;
    EntityName = 'apiPostedDebitNote';
    EntityCaption = 'apiPostedDebitNote';
    EntitySetName = 'apiPostedDebitNotes';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiPostedDebitNotes';
    PageType = API;
    SourceTable = "Purch. Cr. Memo Hdr.";

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
                    ToolTip = 'Specifies the posted credit memo number.';
                }
                field("postingDate"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date';
                    ToolTip = 'Specifies the date the credit memo was posted.';
                }
                field("buyFromVendorNo"; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    Caption = 'Buy-from Vendor No.';
                    ToolTip = 'Specifies the name of the vendor who delivered the items.';
                }
                field("buyFromVendorName"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                    Caption = 'Buy-from Vendor Name';
                    ToolTip = 'Specifies the name of the vendor who shipped the items.';
                }
                field(amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ToolTip = 'Specifies the total, in the currency of the credit memo, of the amounts on all the credit memo lines.';
                }
                field("amountIncludingVAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Amount Including VAT';
                    ToolTip = 'Specifies the total of the amounts, including VAT, on all the lines on the document.';
                }
                field("recordCount"; RecCnt_gInt)
                {
                    ApplicationArea = All;
                    Caption = 'Record Count';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Record Count field.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        RecCnt_gInt += 1;
    end;

    trigger OnOpenPage()
    var
        INTKeyValidationMgt: Codeunit "IKV Mgt";
    begin
        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();
        Rec.SetCurrentKey("Posting Date");
        Rec.Ascending(false);

        //T39004-NS NG 08092023
        IF Rec.GETFILTER("Buy-from Vendor No.") = '' THEN
            ERROR('Apply Vendor filter Require, (Referesh Browser and Login again)');
        //T39004-NE
    end;

    var
        RecCnt_gInt: Integer;
}

