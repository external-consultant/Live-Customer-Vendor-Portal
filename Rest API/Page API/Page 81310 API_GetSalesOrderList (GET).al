page 81310 "API_GetSalesOrderList"
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiGetSalesOrderList';
    DelayedInsert = true;
    EntityName = 'apiGetSalesOrderList';
    EntityCaption = 'apiGetSalesOrderList';
    EntitySetName = 'apiGetSalesOrderLists';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiGetSalesOrderLists';
    PageType = API;
    SourceTable = "Sales Header";
    SourceTableView = where("Document Type" = filter('Order'), "Completely Shipped" = const(false));

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
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }
                field(invoiceDiscountAmount; Rec."Invoice Discount Amount")
                {
                    Caption = 'Invoice Discount Amount';
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
                
                
            }
        }
    }
}
