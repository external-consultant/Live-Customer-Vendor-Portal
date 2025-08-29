page 81308 "API_CreateSalesLine"
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiCreateSalesLine';
    DelayedInsert = true;
    EntityName = 'apiCreateSalesLine';
    EntityCaption = 'apiCreateSalesLine';
    EntitySetName = 'apiCreateSalesLines';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiCreateSalesLines';
    PageType = API;
    SourceTable = API_CreateSalesLine;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(documentNo; Rec."Document No")
                {
                    Caption = 'Document No';
                }
                field(lineNo; Rec."Line No")
                {
                    Caption = 'Line No';
                }
                field(customerNo; Rec."Customer No")
                {
                    Caption = 'Customer No';
                }

                field(itemNo; Rec."Item No")
                {
                    Caption = 'Item No';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(description2; Rec."Description 2")
                {
                    Caption = 'Description 2';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
                field(requestReceiptDate; Rec."Request Receipt Date")
                {
                    Caption = 'Request Receipt Date';
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }

                field(processStatus; Rec."Process Status")
                {
                    Caption = 'Process Status';
                }

                field(processErrorLog; Rec."Process Error Log")
                {
                    Caption = 'Process Error Log';
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        Rec.TestField("Document No");
        Rec.TestField("Line No");
        Rec.TestField("Item No");

        Clear(Item_gRec);
        if Item_gRec.Get(Rec."Item No") then begin

            Clear(UnitPrice_gDec);
            Clear(LineAmount_gDec);
            Clear(UOMItem_gCode);

            UnitPrice_gDec := Item_gRec."Unit Price";
            LineAmount_gDec := Item_gRec."Unit Price" * Rec.Quantity;
            UOMItem_gCode := Item_gRec."Base Unit of Measure";

        end else begin

            Error('Item with Item No %1 does not exist', Rec."Item No");
            Rec."Process Status" := Rec."Process Status"::Failed;
            Rec."Process Error Log" := 'Item with Item No ' + Rec."Item No" + ' does not exist';

        end;

        Clear(SalesHeader_gRec);
        if Not SalesHeader_gRec.Get(SalesHeader_gRec."Document Type"::Order, Rec."Document No") then begin
            Error('Sales Header with Document No %1 does not exist', Rec."Document No");
            Rec."Process Status" := Rec."Process Status"::Failed;
            Rec."Process Error Log" := 'Sales Header with Document No ' + Rec."Document No" + ' does not exist';
        end;

        Clear(SalesLine_gRec);
        if SalesLine_gRec.Get(SalesLine_gRec."Document Type"::Order, Rec."Document No", Rec."Line No") then begin

            SalesLine_gRec.Type := SalesLine_gRec.Type::Item;
            SalesLine_gRec.Validate("Line No.", Rec."Line No");
            SalesLine_gRec."No." := Rec."Item No";
            SalesLine_gRec.Validate(Description, Rec.Description);
            SalesLine_gRec.Validate("Description 2", Rec."Description 2");
            SalesLine_gRec.Validate(Quantity, Rec.Quantity);
            SalesLine_gRec.Validate("Requested Delivery Date", Rec."Request Receipt Date");
            SalesLine_gRec.Validate("Unit Price", UnitPrice_gDec);
            SalesLine_gRec.Validate("Line Amount", LineAmount_gDec);
            SalesLine_gRec.Validate("Location Code", Rec."Location Code");
            SalesLine_gRec.Validate("Unit of Measure", UOMItem_gCode);

            SalesLine_gRec.Modify();

        end else begin

            Clear(SalesLine_gRec);
            SalesLine_gRec.Init();

            SalesLine_gRec.Validate("Document Type", SalesLine_gRec."Document Type"::Order);
            SalesLine_gRec.Validate("Document No.", Rec."Document No");
            SalesLine_gRec.Type := SalesLine_gRec.Type::Item;
            SalesLine_gRec.Validate("Line No.", Rec."Line No");
            SalesLine_gRec."No." := Rec."Item No";
            SalesLine_gRec.Validate(Description, Rec.Description);
            SalesLine_gRec.Validate("Description 2", Rec."Description 2");
            SalesLine_gRec.Validate(Quantity, Rec.Quantity);
            SalesLine_gRec.Validate("Requested Delivery Date", Rec."Request Receipt Date");
            SalesLine_gRec.Validate("Unit Price", UnitPrice_gDec);
            SalesLine_gRec.Validate("Line Amount", LineAmount_gDec);
            SalesLine_gRec.Validate("Location Code", Rec."Location Code");
            SalesLine_gRec.Validate("Unit of Measure", UOMItem_gCode);

            SalesLine_gRec.Insert();

            Rec."Process Status" := Rec."Process Status"::Success;

        end;
    end;

    var
        SalesLine_gRec: Record "Sales Line";
        SalesHeader_gRec: Record "Sales Header";
        Item_gRec: Record Item;
        DocumentNo_gCode: Code[20];
        NumberSeriesMgt_gCdu: Codeunit NoSeriesManagement;
        SalesandRecSetup_gRec: Record "Sales & Receivables Setup";
        UnitPrice_gDec: Decimal;
        LineAmount_gDec: Decimal;
        UOMItem_gCode: Code[20];

}
