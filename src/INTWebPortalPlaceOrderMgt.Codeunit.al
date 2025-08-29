codeunit 81237 "INT WebPortal-PlaceOrder Mgt."
{
    // version WebPortal

    Permissions = tabledata 36 = rim,
                  tabledata 37 = rim;

    trigger OnRun()
    begin
    end;

    procedure AddOrderDraft_gFnc(LoginType_iTxt: Text[50]; AccNo_iCod: Code[20]; ItemNo_iCod: Code[20]; Qty_iDec: Decimal; RequestedDate_iDte: Date; RequestedRcpt_iDte: Date; Remarks_iTxt: Text[250]; CustomerCode_iCod: Code[20]): Boolean
    var
        Customer1_lRec: Record Customer;
        Customer_lRec: Record Customer;
        WebPortalSalesOrderLine_lRec: Record "INT - Sales Order Line";
        Item_lRec: Record Item;
        SalespersonPurchaser_lRec: Record "Salesperson/Purchaser";
        LoginType_lOpt: Option " ",Customer,Vendor,SalesPerson;
    begin
        if LoginType_iTxt = '' then
            Error('Login Type should be either Customer or SalesPerson');
        if AccNo_iCod = '' then
            Error('Account No. must have a value.');

        Evaluate(LoginType_lOpt, LoginType_iTxt);

        if LoginType_iTxt = 'Customer' then begin
            Clear(Customer_lRec);
            if not Customer_lRec.Get(AccNo_iCod) then
                Error('Customer %1 not find in Customer Table.', AccNo_iCod);
        end else begin
            Clear(SalespersonPurchaser_lRec);
            if not SalespersonPurchaser_lRec.Get(AccNo_iCod) then
                Error('Sales Person %1 not find in Sales Person Table.', AccNo_iCod);
        end;


        if ItemNo_iCod = '' then
            Error('Item No. must have a value.');
        if Qty_iDec = 0 then
            Error('Quantity must have a value. It cannot be blank or zero.');
        if RequestedDate_iDte = 0D then
            Error('Requested Date must have a value');
        if RequestedRcpt_iDte = 0D then
            Error('Requested Receipt Date must have a value');

        Item_lRec.Get(ItemNo_iCod);

        WebPortalSalesOrderLine_lRec.Reset();
        WebPortalSalesOrderLine_lRec.Init();
        WebPortalSalesOrderLine_lRec.Validate("Order Created By", LoginType_lOpt);

        if LoginType_lOpt = LoginType_lOpt::Customer then begin
            WebPortalSalesOrderLine_lRec.Validate("Customer No.", AccNo_iCod);
            WebPortalSalesOrderLine_lRec.Validate("Customer Name", Customer_lRec.Name);
        end else begin
            WebPortalSalesOrderLine_lRec.Validate("Sales Person Code", AccNo_iCod);
            WebPortalSalesOrderLine_lRec.Validate("Sales Person Name", SalespersonPurchaser_lRec.Name);
            Clear(Customer1_lRec);
            if Customer1_lRec.Get(CustomerCode_iCod) then;
            WebPortalSalesOrderLine_lRec.Validate("Customer No.", CustomerCode_iCod);
            WebPortalSalesOrderLine_lRec.Validate("Customer Name", Customer1_lRec.Name);
        end;

        WebPortalSalesOrderLine_lRec.Validate("Item No.", ItemNo_iCod);
        WebPortalSalesOrderLine_lRec.Validate(Description, Item_lRec.Description);
        WebPortalSalesOrderLine_lRec.Validate("Description 2", Item_lRec."Description 2");
        WebPortalSalesOrderLine_lRec.Validate("Base Unit of Measure", Item_lRec."Base Unit of Measure");
        WebPortalSalesOrderLine_lRec.Validate(Quantity, Qty_iDec);
        WebPortalSalesOrderLine_lRec.Validate("Requested Date", RequestedDate_iDte);
        WebPortalSalesOrderLine_lRec.Validate("Requested Receipt Date", RequestedRcpt_iDte);
        WebPortalSalesOrderLine_lRec.Validate(Remarks, Remarks_iTxt);

        WebPortalSalesOrderLine_lRec.Insert(true);
        exit(true);
    end;

    procedure DeleteOrder_gFnc(EntryNo_iInt: Integer): Boolean
    var
        WebPortalSalesOrderLine_lRec: Record "INT - Sales Order Line";
    begin
        Clear(WebPortalSalesOrderLine_lRec);
        if not WebPortalSalesOrderLine_lRec.Get(EntryNo_iInt) then
            Error('There is no Sales Order Entry exists with Entry No. %1', EntryNo_iInt);

        WebPortalSalesOrderLine_lRec.Delete(true);
        exit(true);
    end;
}

