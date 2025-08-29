page 81248 "INT - Pending Sales Inv."
{
    // version WebPortal

    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Sales Header";
    SourceTableView = sorting("Document Type", "No.")
                      where("Document Type" = const(Invoice));

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
                    ToolTip = 'Specifies the number of the estimate.';
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = All;
                    Caption = 'Bill-to Customer No.';
                    ToolTip = 'Specifies the number of the customer that you send or sent the invoice or credit memo to.';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'External Document No.';
                    ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    Caption = 'Document Date';
                    ToolTip = 'Specifies when the sales invoice was created.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date';
                    ToolTip = 'Specifies the date when the posting of the sales document will be recorded.';
                }
                field("Amount to Customer"; Round(Rec."Amount Including VAT", 1))
                {
                    ApplicationArea = All;
                    Caption = 'Amount to Customer';
                    ToolTip = 'Specifies the value of the Amount to Customer field.';
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
                    WebPortalReportPrints.PrintPendingSalesInvoice_gFnc(Rec."No.", SingleInstance.GetUserName());
                end;
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
    end;
}

