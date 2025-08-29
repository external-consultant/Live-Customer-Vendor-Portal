page 81260 "API_Web-Posted Cred Note"
{
    // version WebPortal

    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiWebPostedCredNote';
    DelayedInsert = true;
    EntityName = 'apiWebPostedCredNote';
    EntityCaption = 'apiWebPostedCredNote';
    EntitySetName = 'apiWebPostedCredNotes';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiWebPostedCredNotes';
    PageType = API;
    SourceTable = "Sales Cr.Memo Header";

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
                field(postingDate; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date';
                    ToolTip = 'Specifies the date on which the credit memo was posted.';
                }
                field(selltoCustomerNo; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    Caption = 'Sell-to Customer No.';
                    ToolTip = 'Specifies the number of the customer.';
                }
                field(selltoCustomerName; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    Caption = 'Sell-to Customer Name';
                    ToolTip = 'Specifies the name of the customer that you shipped the items on the credit memo to.';
                }
                field(shiptoCode; Rec."Ship-to Code")
                {
                    ApplicationArea = All;
                    Caption = 'Ship-to Code';
                    ToolTip = 'Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.';
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
                    ToolTip = 'Specifies the total of the amounts on all the credit memo lines, in the currency of the credit memo. The amount does not include VAT.';
                }
                field(amountIncludingVAT; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Amount Including VAT';
                    ToolTip = 'Specifies the total of the amounts, including VAT, on all the lines on the document.';
                }
                field(recordCount; RecCnt_gInt)
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
    // INTKeyValidationMgt: Codeunit "INT Key Validation Mgt_";
    begin
        // Clear(INTKeyValidationMgt);
        // INTKeyValidationMgt.onOpenPageKeyValidation();

        Rec.SetCurrentKey("Posting Date");
        Rec.Ascending(false);

        //T39004-NS NG 08092023
        IF Rec.GETFILTER("Sell-to Customer No.") = '' THEN
            ERROR('Apply Customer filter Require, (Referesh Browser and Login again)');
        //T39004-NE
    end;

    var
        RecCnt_gInt: Integer;
}

