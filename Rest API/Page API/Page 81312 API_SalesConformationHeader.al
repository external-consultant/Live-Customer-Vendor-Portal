page 81312 "API_SalesConformationHeader"
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiSalesConformationHeader';
    DelayedInsert = true;
    EntityName = 'apiSalesConformationHeader';
    EntityCaption = 'apiSalesConformationHeader';
    EntitySetName = 'apiSalesConformationHeaders';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiSalesConformationHeaders';
    PageType = API;
    SourceTable = API_SalesConformationHeader;
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
                field(orderConfirmed; Rec."Order Confirmed")
                {
                    Caption = 'Order Confirmed';
                }
                field(conformationRemarks; Rec."Conformation Remarks")
                {
                    Caption = 'Conformation Remarks';
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

        Rec.TestField("Order Confirmed");
        Rec.TestField("Document No");
        Rec.TestField("Conformation Remarks");

        Clear(SalesHeader_gRec);
        if SalesHeader_gRec.Get(SalesHeader_gRec."Document Type"::Order, Rec."Document No") then begin

            SalesHeader_gRec."Order Confirmed" := true;
            SalesHeader_gRec."Order Confirmed Date" := Today;
            SalesHeader_gRec."Comformation Remarks" := Rec."Conformation Remarks";

            SalesHeader_gRec.Modify();
            Rec."Process Status" := Rec."Process Status"::Success;

        end else begin

            Error('Sales Header with No %1 Not Found', Rec."Document No");
            Rec."Process Status" := Rec."Process Status"::Failed;
            Rec."Process Error Log" := 'Sales Header with No ' + Rec."Document No" + ' Not Found';

        end;

    end;

    var

        SalesHeader_gRec: Record "Sales Header";

}
