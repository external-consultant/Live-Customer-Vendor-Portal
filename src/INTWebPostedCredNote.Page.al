page 81234 "INT Web-Posted Cred.Note"
{
    // version WebPortal

    Caption = 'Credit Notes';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Sales Cr.Memo Header";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                    ToolTip = 'Specifies the posted credit memo number.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date';
                    ToolTip = 'Specifies the date on which the credit memo was posted.';
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    Caption = 'Sell-to Customer No.';
                    ToolTip = 'Specifies the number of the customer.';
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    Caption = 'Sell-to Customer Name';
                    ToolTip = 'Specifies the name of the customer that you shipped the items on the credit memo to.';
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = All;
                    Caption = 'Ship-to Code';
                    ToolTip = 'Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.';
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = All;
                    Caption = 'Ship-to Name';
                    ToolTip = 'Specifies the name of the customer that the items were shipped to.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ToolTip = 'Specifies the total of the amounts on all the credit memo lines, in the currency of the credit memo. The amount does not include VAT.';
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Amount Including VAT';
                    ToolTip = 'Specifies the total of the amounts, including VAT, on all the lines on the document.';
                }
                field("Record Count"; RecCnt_gInt)
                {
                    ApplicationArea = All;
                    Caption = 'Record Count';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Record Count field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Print Email")
            {
                ApplicationArea = All;
                Caption = 'Print Email';
                Image = Email;
                ToolTip = 'Executes the Print Email action.';

                trigger OnAction()
                var
                    SingleInstance: Codeunit "INT Single Instance";
                    WebPortalReportPrints: Codeunit "INT Web Portal Report (Email)";
                begin
                    Clear(WebPortalReportPrints);
                    WebPortalReportPrints.PrintPostedSalesCreditNote_gFnc(Rec."No.", SingleInstance.GetUserName());
                end;
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
    end;

    var
        RecCnt_gInt: Integer;
}

