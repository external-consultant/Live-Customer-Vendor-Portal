page 81309 "API_GetSalesOrder"
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiGetSalesOrder';
    DelayedInsert = true;
    EntityName = 'apiGetSalesOrder';
    EntityCaption = 'apiGetSalesOrder';
    EntitySetName = 'apiGetSalesOrders';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiGetSalesOrders';
    PageType = API;
    SourceTable = "Sales Header";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(yourReference; Rec."Your Reference")
                {
                    Caption = 'Your Reference';
                }
                field(documentType; Rec."Document Type")
                {
                    Caption = 'Document Type';
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(sellToCustomerNo; Rec."Sell-to Customer No.")
                {
                    Caption = 'Sell-to Customer No.';
                }
                field(sellToCustomerName; Rec."Sell-to Customer Name")
                {
                    Caption = 'Sell-to Customer Name';
                }
                field(orderDate; Rec."Order Date")
                {
                    Caption = 'Order Date';
                }
                field(referenceInvoiceNo; Rec."Reference Invoice No.")
                {
                    Caption = 'Reference Invoice No.';
                }
                field(shipmentStatus; Rec."Shipment Status")
                {
                    Caption = 'Shipment Status';
                }
                field(packageTrackingNo; Rec."Package Tracking No")
                {
                    Caption = 'Package Tracking No';
                }
                
            }
        }
    }

    trigger OnOpenPage()
    var
    begin
        IF Rec.GETFILTER("No.") = '' THEN
            ERROR('No Filter Required');
    end;
}
