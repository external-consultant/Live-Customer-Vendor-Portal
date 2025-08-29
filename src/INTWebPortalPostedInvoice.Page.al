page 81233 "INT Web Portal-Posted Invoice"
{
    // version WebPortal

    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Sales Invoice Header";
    SourceTableView = sorting("Posting Date")
                      order(descending);

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
                    ToolTip = 'Specifies the number of the record.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date';
                    ToolTip = 'Specifies the date on which the invoice was posted.';
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    Caption = 'Sell-to Customer No.';
                    ToolTip = 'Specifies the number of the customer the invoice concerns.';
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    Caption = 'Sell-to Customer Name';
                    ToolTip = 'Specifies the customer''s name.';
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = All;
                    Caption = 'Ship-to Code';
                    ToolTip = 'Specifies the address on purchase orders shipped with a drop shipment directly from the vendor to a customer.';
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
                    ToolTip = 'Specifies the total amount on the sales invoice excluding VAT.';
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Amount Including VAT';
                    ToolTip = 'Specifies the total amount on the sales invoice including VAT.';
                }
                field("Record Count"; RecCnt_gInt)
                {
                    ApplicationArea = All;
                    Caption = 'Record Count';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Record Count field.';
                }
                field(ExternalDocNo_gCod; ExternalDocNo_gCod)
                {
                    ApplicationArea = All;
                    Caption = 'ExternalDocNo_gCod';
                    ToolTip = 'Specifies the value of the ExternalDocNo_gCod field.';
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
                    WebPortalReportPrints.PrintPostedSalesInvoice_gFnc(Rec."No.", SingleInstance.GetUserName());
                end;
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
    end;

    var
        ExternalDocNo_gCod: Code[35];
        RecCnt_gInt: Integer;
}

