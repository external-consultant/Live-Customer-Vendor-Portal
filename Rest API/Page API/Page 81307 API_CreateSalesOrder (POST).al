page 81307 "API_CreateSalesOrder"
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiCreateSalesOrder';
    DelayedInsert = true;
    EntityName = 'apiCreateSalesOrder';
    EntityCaption = 'apiCreateSalesOrder';
    EntitySetName = 'apiCreateSalesOrders';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiCreateSalesOrders';
    PageType = API;
    SourceTable = API_CreateSalesOrder;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(customerNo; Rec."Customer No")
                {
                    Caption = 'Customer No';
                }
                field(orderDate; Rec."Order Date")
                {
                    Caption = 'Order Date';
                }
                field(referenceNo; Rec."Reference No")
                {
                    Caption = 'Reference No';
                }
                field(remarks; Rec.Remarks)
                {
                    Caption = 'Remarks';
                }
                field(documentno; DocumentNo_gCode)
                {
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

        Clear(Customer_gRec);
        if Customer_gRec.Get(Rec."Customer No") then begin
            CustomerName_gTxt := Customer_gRec.Name + Customer_gRec."Name 2";
        end else begin
            Error('Customer with Customer No %1 does not exist', Rec."Customer No");
            Rec."Process Status" := Rec."Process Status"::Failed;
            Rec."Process Error Log" := 'Customer with Customer No ' + Rec."Customer No" + ' does not exist';
        end;

        Clear(SalesHeader_gRec);
        SalesHeader_gRec.Init();

        Clear(NumberSeriesMgt_gCdu);

        Clear(SalesandRecSetup_gRec);
        SalesandRecSetup_gRec.Get();

        SalesHeader_gRec."Document Type" := SalesHeader_gRec."Document Type"::Order;
        SalesHeader_gRec."No." := NumberSeriesMgt_gCdu.GetNextNo(SalesandRecSetup_gRec."Order Nos.", TODAY, true);
        SalesHeader_gRec."Sell-to Customer No." := Rec."Customer No";
        SalesHeader_gRec."Sell-to Customer Name" := CustomerName_gTxt;
        SalesHeader_gRec."Order Date" := Rec."Order Date";
        SalesHeader_gRec."Your Reference" := Rec."Reference No";
        // SalesHeader_gRec."Work Description" := Rec.Remarks;

        SalesHeader_gRec.Insert();

        DocumentNo_gCode := SalesHeader_gRec."No.";

        Rec."Process Status" := Rec."Process Status"::Success;

    end;

    var
        SalesHeader_gRec: Record "Sales Header";
        Customer_gRec: Record Customer;
        DocumentNo_gCode: Code[20];
        NumberSeriesMgt_gCdu: Codeunit NoSeriesManagement;
        SalesandRecSetup_gRec: Record "Sales & Receivables Setup";
        CustomerName_gTxt: Text[50];

}
