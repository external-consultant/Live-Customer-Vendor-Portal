page 81236 "INT Web Portal-Pend Purch Ord"
{
    // version WebPortal

    Caption = 'Pending Orders';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Purchase Line";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    Caption = 'Buy-from Vendor No.';
                    ToolTip = 'Specifies the name of the vendor who delivered the items.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'Document No.';
                    ToolTip = 'Specifies the document number.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    ToolTip = 'Specifies the line type.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(OrderNo_gCod; OrderNo_gCod)
                {
                    ApplicationArea = All;
                    Caption = 'Order No.';
                    ToolTip = 'Specifies the value of the Order No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    ToolTip = 'Specifies a description of the blanket purchase order.';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    Caption = 'Description 2';
                    ToolTip = 'Specifies information in addition to the description.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Caption = 'Quantity';
                    ToolTip = 'Specifies the quantity of the purchase order line.';
                }
                field("Qty. Rcd. Not Invoiced"; Rec."Qty. Rcd. Not Invoiced")
                {
                    ApplicationArea = All;
                    Caption = 'Qty. Rcd. Not Invoiced';
                    ToolTip = 'Specifies the value of the Qty. Rcd. Not Invoiced field.';
                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                    ApplicationArea = All;
                    Caption = 'Quantity Received';
                    ToolTip = 'Specifies how many units of the item on the line have been posted as received.';
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    ApplicationArea = All;
                    Caption = 'Outstanding Quantity';
                    ToolTip = 'Specifies how many units on the order line have not yet been received.';
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = All;
                    Caption = 'Expected Receipt Date';
                    ToolTip = 'Specifies the date you expect the items to be available in your warehouse.';
                }
                field("Document Date"; DocumentDate_gDte)
                {
                    ApplicationArea = All;
                    Caption = 'Document Date';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Document Date field.';
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
                    WebPortalReportPrints.PrintPurchaseOrder_gFnc(Rec."No.", SingleInstance.GetUserName());
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        PurchHdr_lRec: Record "Purchase Header";
    begin
        OrderNo_gCod := '';
        DocumentDate_gDte := 0D;

        Clear(PurchHdr_lRec);
        if PurchHdr_lRec.Get(Rec."Document Type", Rec."Document No.") then begin
            OrderNo_gCod := PurchHdr_lRec."Vendor Order No.";
            DocumentDate_gDte := PurchHdr_lRec."Document Date";
        end;
    end;

    trigger OnOpenPage()
    var
        INTKeyValidationMgt: Codeunit "IKV Mgt";
    begin
        Clear(INTKeyValidationMgt);
        // INTKeyValidationMgt.onOpenPageKeyValidation();
    end;

    var
        OrderNo_gCod: Code[35];
        DocumentDate_gDte: Date;
}

