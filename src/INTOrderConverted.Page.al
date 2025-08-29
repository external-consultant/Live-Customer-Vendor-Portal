page 81252 "INT - Order Converted"
{
    // version WebPortal

    Caption = 'Orders Converted';
    PageType = List;
    SourceTable = "INT - Sales Order Line";
    SourceTableView = where("Order Converted" = filter(true));

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No.';
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Caption = 'Customer No.';
                    ToolTip = 'Specifies the value of the Customer No. field.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    Caption = 'Customer Name';
                    ToolTip = 'Specifies the value of the Customer Name field.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Caption = 'Item No.';
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    Caption = 'Description 2';
                    ToolTip = 'Specifies the value of the Description 2 field.';
                }
                field("Requested Date"; Rec."Requested Date")
                {
                    ApplicationArea = All;
                    Caption = 'Requested Date';
                    ToolTip = 'Specifies the value of the Requested Date field.';
                }
                field("Requested Receipt Date"; Rec."Requested Receipt Date")
                {
                    ApplicationArea = All;
                    Caption = 'Requested Receipt Date';
                    ToolTip = 'Specifies the value of the Requested Receipt Date field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Caption = 'Quantity';
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    Caption = 'Remarks';
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field("Created Sales Order No."; Rec."Created Sales Order No.")
                {
                    ApplicationArea = All;
                    Caption = 'Created Sales Order No.';
                    ToolTip = 'Specifies the value of the Created Sales Order No. field.';
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                    Caption = 'Base Unit of Measure';
                    ToolTip = 'Specifies the value of the Base Unit of Measure field.';
                }
                field("Order Created By"; Rec."Order Created By")
                {
                    ApplicationArea = All;
                    Caption = 'Order Created By';
                    ToolTip = 'Specifies the value of the Order Created By field.';
                }
                field("Sales Person Name"; Rec."Sales Person Name")
                {
                    ApplicationArea = All;
                    Caption = 'Sales Person Name';
                    ToolTip = 'Specifies the value of the Sales Person Name field.';
                }
                field("Sales Person Code"; Rec."Sales Person Code")
                {
                    ApplicationArea = All;
                    Caption = 'Sales Person Code';
                    ToolTip = 'Specifies the value of the Sales Person Code field.';
                }
                field("Order Converted"; Rec."Order Converted")
                {
                    ApplicationArea = All;
                    Caption = 'Order Converted';
                    ToolTip = 'Specifies the value of the Order Converted field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Create Sales Order")
            {
                ApplicationArea = All;
                Caption = 'Create Sales Order';
                Image = CreateDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Create Sales Order action.';

                trigger OnAction()
                var
                    WebPortalSalesOrderLine_lRec: Record "INT - Sales Order Line";
                    CreatedSalesOrderNo_lCod: Code[20];
                begin
                    PreCustomerNo_gCod := '';
                    CurrRec := 0;
                    NoOfRecs := 0;
                    Windows.Open(Text001Lbl + Text002Lbl);
                    CurrPage.SetSelectionFilter(WebPortalSalesOrderLine_lRec);
                    WebPortalSalesOrderLine_lRec.SetCurrentKey("Customer No.");
                    if WebPortalSalesOrderLine_lRec.FindSet() then begin
                        NoOfRecs := WebPortalSalesOrderLine_lRec.Count();
                        repeat

                            Windows.Update(1, WebPortalSalesOrderLine_lRec."Entry No.");
                            CurrRec += 1;
                            if NoOfRecs <= 100 then
                                Windows.Update(2, (CurrRec / NoOfRecs * 10000) div 1)
                            else
                                if CurrRec mod NoOfRecs div 100 = 0 then
                                    Windows.Update(2, (CurrRec / NoOfRecs * 10000) div 1);

                            if PreCustomerNo_gCod <> WebPortalSalesOrderLine_lRec."Customer No." then begin
                                CreatedSalesOrderNo_lCod := CreateSalesHeader_lFnc(WebPortalSalesOrderLine_lRec);
                                CreateSalesLine_lFnc(WebPortalSalesOrderLine_lRec, CreatedSalesOrderNo_lCod);
                            end else
                                CreateSalesLine_lFnc(WebPortalSalesOrderLine_lRec, CreatedSalesOrderNo_lCod);

                            PreCustomerNo_gCod := WebPortalSalesOrderLine_lRec."Customer No.";

                        until WebPortalSalesOrderLine_lRec.Next() = 0;
                    end;
                    Windows.Close();
                end;
            }
        }
    }

    var
        PreCustomerNo_gCod: Code[20];
        Windows: Dialog;
        CurrRec: Integer;
        NoOfRecs: Integer;
        Text002Lbl: Label 'Completed       @2@@@@@@@@@@';
        Text001Lbl: Label 'Processing No.  #1##########\', Comment = '#1##########=No.';

    trigger OnOpenPage()
    var
        INTKeyValidationMgt: Codeunit "IKV Mgt";
    begin
        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();
    end;

    local procedure CreateSalesHeader_lFnc(WebPortalSalesOrderLine_iRec: Record "INT - Sales Order Line"): Code[20]
    var
        SalesHeader_lRec: Record "Sales Header";
    begin
        SalesHeader_lRec.Init();
        SalesHeader_lRec."Document Type" := SalesHeader_lRec."Document Type"::Order;
        if SalesHeader_lRec.Insert(true) then begin
            SalesHeader_lRec.Validate("Sell-to Customer No.", WebPortalSalesOrderLine_iRec."Customer No.");
            SalesHeader_lRec.Validate("Salesperson Code", WebPortalSalesOrderLine_iRec."Sales Person Code");
            SalesHeader_lRec.Modify();
        end;
        exit(SalesHeader_lRec."No.");
    end;

    local procedure CreateSalesLine_lFnc(var WebPortalSalesOrderLine_vRec: Record "INT - Sales Order Line"; SalesOrderNo_iCod: Code[20])
    var
        PreSalesLine_lRec: Record "Sales Line";
        SalesLine_lRec: Record "Sales Line";
        LineNo_lInt: Integer;
    begin
        LineNo_lInt := 0;

        PreSalesLine_lRec.Reset();
        PreSalesLine_lRec.SetRange("Document Type", PreSalesLine_lRec."Document Type"::Order);
        PreSalesLine_lRec.SetRange("Document No.", SalesOrderNo_iCod);
        if PreSalesLine_lRec.FindLast() then
            LineNo_lInt := PreSalesLine_lRec."Line No." + 10000
        else
            LineNo_lInt := 10000;

        SalesLine_lRec.Init();
        SalesLine_lRec."Document Type" := SalesLine_lRec."Document Type"::Order;
        SalesLine_lRec."Document No." := SalesOrderNo_iCod;
        SalesLine_lRec."Line No." := LineNo_lInt;
        SalesLine_lRec.Validate(Type, SalesLine_lRec.Type::Item);
        SalesLine_lRec.Validate("No.", WebPortalSalesOrderLine_vRec."Item No.");
        SalesLine_lRec.Validate(Quantity, WebPortalSalesOrderLine_vRec.Quantity);
        SalesLine_lRec.Validate("Unit of Measure", WebPortalSalesOrderLine_vRec."Base Unit of Measure");
        SalesLine_lRec.Validate("Requested Delivery Date", WebPortalSalesOrderLine_vRec."Requested Receipt Date");
        SalesLine_lRec.Insert();

        WebPortalSalesOrderLine_vRec."Created Sales Order No." := SalesOrderNo_iCod;
        WebPortalSalesOrderLine_vRec."Created Sales Order Line No." := SalesLine_lRec."Line No.";
        WebPortalSalesOrderLine_vRec."Order Converted" := true;
        WebPortalSalesOrderLine_vRec.Modify();
    end;
}

