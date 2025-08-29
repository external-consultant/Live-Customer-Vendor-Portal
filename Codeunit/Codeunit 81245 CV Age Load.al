Codeunit 81245 "CV Age Load"
{

    trigger OnRun()
    var
        No_iCod: Code[20];
    begin
        ProcessCustomer_gFnc(No_iCod);
        ProcessPurchase_gFnc(No_iCod);
        ProcessVendor_gFnc(No_iCod);
        ProcessSales_gFnc(No_iCod);
    end;

    var
        SD_gDteArr: array[13] of Date;
        ED_gDteArr: array[13] of Date;

    procedure ProcessVendor_gFnc(VendorNo_iCod: Code[20])
    var
        AgeDetails: Record "Age Details";
    begin
        AgeDetails.Reset;
        AgeDetails.SetRange(Source, AgeDetails.Source::"Vendor Age");
        AgeDetails.SetRange("No.", VendorNo_iCod);
        AgeDetails.DeleteAll;

        CalVedorAge_lFnc(VendorNo_iCod, 'Month');
        CalVedorAge_lFnc(VendorNo_iCod, 'Week');
    end;

    procedure ProcessPurchase_gFnc(VendorNo_iCod: Code[20])
    var
        AgeDetails: Record "Age Details";
    begin
        AgeDetails.Reset;
        AgeDetails.SetRange(Source, AgeDetails.Source::Purchases);
        AgeDetails.SetRange("No.", VendorNo_iCod);
        AgeDetails.DeleteAll;

        CalPurchAge_lFnc(VendorNo_iCod, 'Month');
    end;

    procedure ProcessCustomer_gFnc(CustomerNo_iCod: Code[20])
    var
        AgeDetails: Record "Age Details";
    begin
        AgeDetails.Reset;
        AgeDetails.SetRange(Source, AgeDetails.Source::"Customer Age");
        AgeDetails.SetRange("No.", CustomerNo_iCod);
        AgeDetails.DeleteAll;

        CalCustomerAge_lFnc(CustomerNo_iCod, 'Month');
        CalCustomerAge_lFnc(CustomerNo_iCod, 'Week');
    end;

    procedure ProcessSales_gFnc(CustomerNo_iCod: Code[20])
    var
        AgeDetails: Record "Age Details";
    begin
        AgeDetails.Reset;
        AgeDetails.SetRange(Source, AgeDetails.Source::Sales);
        AgeDetails.SetRange("No.", CustomerNo_iCod);
        AgeDetails.DeleteAll;

        CalSalesAge_lFnc(CustomerNo_iCod, 'Month');
    end;

    local procedure CalVedorAge_lFnc(VendorNo_iCod: Code[20]; AgeBy: Text)
    var
        VendorAgeDetails: Record "Age Details";
        i: Integer;
        CF_lTxt: Text[1];
        VLE_lRec: Record "Vendor Ledger Entry";
    begin
        //AgeBy = 'Month' OR 'Week'

        if AgeBy = 'Month' then
            CF_lTxt := 'M';

        if AgeBy = 'Week' then
            CF_lTxt := 'W';

        Clear(SD_gDteArr);
        Clear(ED_gDteArr);

        SD_gDteArr[1] := 20010101D;
        ED_gDteArr[1] := Today - 1;
        Clear(VendorAgeDetails);
        VendorAgeDetails.Init;
        VendorAgeDetails.Source := VendorAgeDetails.Source::"Vendor Age";
        VendorAgeDetails."Age by" := AgeBy;
        VendorAgeDetails.Sequence := 1;
        VendorAgeDetails."No." := VendorNo_iCod;
        VendorAgeDetails.Caption := 'Over Due';
        VendorAgeDetails."Start Date" := SD_gDteArr[1];
        VendorAgeDetails."End Date" := ED_gDteArr[1];
        VendorAgeDetails.CaptionYear := Date2DMY(Today, 3);
        VendorAgeDetails.Insert;

        for i := 2 to 7 do begin
            SD_gDteArr[i] := ED_gDteArr[i - 1] + 1;
            ED_gDteArr[i] := CalcDate('1' + CF_lTxt, SD_gDteArr[i]) - 1;
            Clear(VendorAgeDetails);
            VendorAgeDetails.Init;
            VendorAgeDetails.Source := VendorAgeDetails.Source::"Vendor Age";
            VendorAgeDetails."Age by" := AgeBy;
            VendorAgeDetails.Sequence := i;
            VendorAgeDetails."No." := VendorNo_iCod;
            VendorAgeDetails.Caption := Format(i - 1) + CF_lTxt;
            VendorAgeDetails."Start Date" := SD_gDteArr[i];
            VendorAgeDetails."End Date" := ED_gDteArr[i];
            VendorAgeDetails.CaptionYear := Date2DMY(Today, 3);
            VendorAgeDetails.Insert;
        end;

        SD_gDteArr[8] := ED_gDteArr[7] + 1;
        ED_gDteArr[8] := 99991231D;
        Clear(VendorAgeDetails);
        VendorAgeDetails.Init;
        VendorAgeDetails.Source := VendorAgeDetails.Source::"Vendor Age";
        VendorAgeDetails."Age by" := AgeBy;
        VendorAgeDetails.Sequence := 8;
        VendorAgeDetails."No." := VendorNo_iCod;
        VendorAgeDetails.Caption := 'Not Due';
        VendorAgeDetails."Start Date" := SD_gDteArr[8];
        VendorAgeDetails."End Date" := ED_gDteArr[8];
        VendorAgeDetails.CaptionYear := Date2DMY(Today, 3);
        VendorAgeDetails.Insert;

        //VLE

        VLE_lRec.Reset;
        VLE_lRec.SetRange("Vendor No.", VendorNo_iCod);
        VLE_lRec.SetRange(Open, true);
        if VLE_lRec.FindSet then begin
            repeat
                VLE_lRec.CalcFields("Remaining Amt. (LCY)");

                VendorAgeDetails.Reset;
                VendorAgeDetails.SetRange(Source, VendorAgeDetails.Source::"Vendor Age");
                VendorAgeDetails.SetRange("Age by", AgeBy);
                VendorAgeDetails.SetRange("No.", VendorNo_iCod);
                VendorAgeDetails.SetFilter("Start Date", '<=%1', VLE_lRec."Due Date");
                VendorAgeDetails.SetFilter("End Date", '>=%1', VLE_lRec."Due Date");
                VendorAgeDetails.FindFirst;
                VendorAgeDetails.Amount += (VLE_lRec."Remaining Amt. (LCY)" * -1);
                VendorAgeDetails.Modify;

            until VLE_lRec.Next = 0;
        end;
    end;

    local procedure CalPurchAge_lFnc(VendorNo_iCod: Code[20]; AgeBy: Text)
    var
        VendorAgeDetails: Record "Age Details";
        i: Integer;
        CF_lTxt: Text[1];
        DF_lTxt: Text[2];
        VLE_lRec: Record "Vendor Ledger Entry";
        Year: Integer;
        Month: Integer;
        StartDate: Date;
        EndDate: Date;
        CaptionMonth_lText: Text[20];
        CaptionYear_lInt: Integer;
        currentyear, sequence : Integer;
    begin
        // AgeBy = 'Month' 

        if AgeBy = 'Month' then
            CF_lTxt := 'M';

        Clear(SD_gDteArr);
        Clear(ED_gDteArr);

        Clear(currentyear);
        currentyear := Date2DMY(Today, 3);
        sequence := 0;

        Clear(DF_lTxt);
        DF_lTxt := 'D';

        for i := 0 to 2 do begin
            //currentyear := (currentyear - i);
            Clear(SD_gDteArr);
            Clear(ED_gDteArr);
            for Month := 1 to 12 do begin
                Clear(CaptionMonth_lText);
                sequence := sequence + 1;
                case Month of
                    1:
                        begin
                            SD_gDteArr[Month] := DMY2Date(1, 1, currentyear);
                            ED_gDteArr[Month] := CalcDate('CM', SD_gDteArr[Month]);
                            CaptionMonth_lText := 'January';
                            CaptionYear_lInt := currentyear;
                        end;

                    2:
                        begin
                            SD_gDteArr[Month] := CalcDate('1' + CF_lTxt, SD_gDteArr[Month - 1]);
                            ED_gDteArr[Month] := CalcDate('CM', SD_gDteArr[Month]);
                            CaptionMonth_lText := 'February';
                            CaptionYear_lInt := currentyear;
                        end;

                    3:
                        begin
                            SD_gDteArr[Month] := CalcDate('1' + CF_lTxt, SD_gDteArr[Month - 1]);
                            ED_gDteArr[Month] := CalcDate('CM', SD_gDteArr[Month]);
                            CaptionMonth_lText := 'March';
                            CaptionYear_lInt := currentyear;
                        end;

                    4:
                        begin
                            SD_gDteArr[Month] := CalcDate('1' + CF_lTxt, SD_gDteArr[Month - 1]);
                            ED_gDteArr[Month] := CalcDate('CM', SD_gDteArr[Month]);
                            CaptionMonth_lText := 'April';
                            CaptionYear_lInt := currentyear;
                        end;

                    5:
                        begin
                            SD_gDteArr[Month] := CalcDate('1' + CF_lTxt, SD_gDteArr[Month - 1]);
                            ED_gDteArr[Month] := CalcDate('CM', SD_gDteArr[Month]);
                            CaptionMonth_lText := 'May';
                            CaptionYear_lInt := currentyear;
                        end;

                    6:
                        begin
                            SD_gDteArr[Month] := CalcDate('1' + CF_lTxt, SD_gDteArr[Month - 1]);
                            ED_gDteArr[Month] := CalcDate('CM', SD_gDteArr[Month]);
                            CaptionMonth_lText := 'June';
                            CaptionYear_lInt := currentyear;
                        end;

                    7:
                        begin
                            SD_gDteArr[Month] := CalcDate('1' + CF_lTxt, SD_gDteArr[Month - 1]);
                            ED_gDteArr[Month] := CalcDate('CM', SD_gDteArr[Month]);
                            CaptionMonth_lText := 'July';
                            CaptionYear_lInt := currentyear;
                        end;

                    8:
                        begin
                            SD_gDteArr[Month] := CalcDate('1' + CF_lTxt, SD_gDteArr[Month - 1]);
                            ED_gDteArr[Month] := CalcDate('CM', SD_gDteArr[Month]);
                            CaptionMonth_lText := 'August';
                            CaptionYear_lInt := currentyear;
                        end;

                    9:
                        begin
                            SD_gDteArr[Month] := CalcDate('1' + CF_lTxt, SD_gDteArr[Month - 1]);
                            ED_gDteArr[Month] := CalcDate('CM', SD_gDteArr[Month]);
                            CaptionMonth_lText := 'September';
                            CaptionYear_lInt := currentyear;
                        end;

                    10:
                        begin
                            SD_gDteArr[Month] := CalcDate('1' + CF_lTxt, SD_gDteArr[Month - 1]);
                            ED_gDteArr[Month] := CalcDate('CM', SD_gDteArr[Month]);
                            CaptionMonth_lText := 'Ocotber';
                            CaptionYear_lInt := currentyear;
                        end;

                    11:
                        begin
                            SD_gDteArr[Month] := CalcDate('1' + CF_lTxt, SD_gDteArr[Month - 1]);
                            ED_gDteArr[Month] := CalcDate('CM', SD_gDteArr[Month]);
                            CaptionMonth_lText := 'November';
                            CaptionYear_lInt := currentyear;
                        end;

                    12:
                        begin
                            SD_gDteArr[Month] := CalcDate('1' + CF_lTxt, SD_gDteArr[Month - 1]);
                            ED_gDteArr[Month] := CalcDate('CM', SD_gDteArr[Month]);
                            CaptionMonth_lText := 'December';
                            CaptionYear_lInt := currentyear;
                        end;

                    else
                        Message('Not');

                end;

                Clear(VendorAgeDetails);
                VendorAgeDetails.Init;
                VendorAgeDetails.Source := VendorAgeDetails.Source::Purchases;
                VendorAgeDetails."Age by" := AgeBy;
                VendorAgeDetails.Sequence := sequence;
                VendorAgeDetails."No." := VendorNo_iCod;
                VendorAgeDetails.Caption := CaptionMonth_lText;
                VendorAgeDetails."Start Date" := SD_gDteArr[Month];
                VendorAgeDetails."End Date" := ED_gDteArr[Month];
                VendorAgeDetails.CaptionYear := CaptionYear_lInt;
                VendorAgeDetails.Insert;

            end;
            currentyear := currentyear - 1;
        end;

        //VLE
        VLE_lRec.Reset;
        VLE_lRec.SetRange("Vendor No.", VendorNo_iCod);
        // VLE_lRec.SetRange(Open, true);
        VLE_lRec.SetFilter("Document Type", '=%1|%2', VLE_lRec."Document Type"::Invoice, VLE_lRec."Document Type"::"Credit Memo");
        if VLE_lRec.FindSet then begin
            repeat
                VLE_lRec.CalcFields("Amount (LCY)");

                VendorAgeDetails.Reset;
                VendorAgeDetails.SetRange(Source, VendorAgeDetails.Source::Purchases);
                VendorAgeDetails.SetRange("Age by", AgeBy);
                VendorAgeDetails.SetRange("No.", VendorNo_iCod);
                VendorAgeDetails.SetFilter("Start Date", '<=%1', VLE_lRec."Posting Date");
                VendorAgeDetails.SetFilter("End Date", '>=%1', VLE_lRec."Posting Date");
                if VendorAgeDetails.FindFirst then begin
                    VendorAgeDetails.Amount += (VLE_lRec."Amount (LCY)" * -1);
                    VendorAgeDetails.Modify;
                end;

            until VLE_lRec.Next = 0;
        end;
    end;

    local procedure CalCustomerAge_lFnc(CustomerNo_iCod: Code[20]; AgeBy: Text)
    var
        AgeDetails: Record "Age Details";
        i: Integer;
        CF_lTxt: Text[1];
        CLE_lRec: Record "Cust. Ledger Entry";
    begin

        //AgeBy = 'Month' OR 'Week'

        if AgeBy = 'Month' then
            CF_lTxt := 'M';

        if AgeBy = 'Week' then
            CF_lTxt := 'W';

        Clear(SD_gDteArr);
        Clear(ED_gDteArr);

        SD_gDteArr[1] := 20010101D;
        ED_gDteArr[1] := Today - 1;
        Clear(AgeDetails);
        AgeDetails.Init;
        AgeDetails.Source := AgeDetails.Source::"Customer Age";
        AgeDetails."Age by" := AgeBy;
        AgeDetails.Sequence := 1;
        AgeDetails."No." := CustomerNo_iCod;
        AgeDetails.Caption := 'Over Due';
        AgeDetails."Start Date" := SD_gDteArr[1];
        AgeDetails."End Date" := ED_gDteArr[1];
        AgeDetails.CaptionYear := Date2DMY(Today, 3);
        AgeDetails.Insert;

        for i := 2 to 7 do begin
            SD_gDteArr[i] := ED_gDteArr[i - 1] + 1;
            ED_gDteArr[i] := CalcDate('1' + CF_lTxt, SD_gDteArr[i]) - 1;
            Clear(AgeDetails);
            AgeDetails.Init;
            AgeDetails.Source := AgeDetails.Source::"Customer Age";
            AgeDetails."Age by" := AgeBy;
            AgeDetails.Sequence := i;
            AgeDetails."No." := CustomerNo_iCod;
            AgeDetails.Caption := Format(i - 1) + CF_lTxt;
            AgeDetails."Start Date" := SD_gDteArr[i];
            AgeDetails."End Date" := ED_gDteArr[i];
            AgeDetails.CaptionYear := Date2DMY(Today, 3);
            AgeDetails.Insert;
        end;

        SD_gDteArr[8] := ED_gDteArr[7] + 1;
        ED_gDteArr[8] := 99991231D;
        Clear(AgeDetails);
        AgeDetails.Init;
        AgeDetails.Source := AgeDetails.Source::"Customer Age";
        AgeDetails."Age by" := AgeBy;
        AgeDetails.Sequence := 8;
        AgeDetails."No." := CustomerNo_iCod;
        AgeDetails.Caption := 'Not Due';
        AgeDetails."Start Date" := SD_gDteArr[8];
        AgeDetails."End Date" := ED_gDteArr[8];
        AgeDetails.CaptionYear := Date2DMY(Today, 3);
        AgeDetails.Insert;

        //CLE
        CLE_lRec.Reset;
        CLE_lRec.SetRange("Customer No.", CustomerNo_iCod);
        CLE_lRec.SetRange(Open, true);
        if CLE_lRec.FindSet then begin
            repeat
                CLE_lRec.CalcFields("Remaining Amt. (LCY)");

                AgeDetails.Reset;
                AgeDetails.SetRange(Source, AgeDetails.Source::"Customer Age");
                AgeDetails.SetRange("Age by", AgeBy);
                AgeDetails.SetRange("No.", CustomerNo_iCod);
                AgeDetails.SetFilter("Start Date", '<=%1', CLE_lRec."Due Date");
                AgeDetails.SetFilter("End Date", '>=%1', CLE_lRec."Due Date");
                AgeDetails.FindFirst;
                AgeDetails.Amount += (CLE_lRec."Remaining Amt. (LCY)" * 1);
                AgeDetails.Modify;

            until CLE_lRec.Next = 0;
        end;
        
    end;

    local procedure CalSalesAge_lFnc(CustomerNo_iCod: Code[20]; AgeBy: Text)
    var
        AgeDetails: Record "Age Details";
        i: Integer;
        CF_lTxt: Text[1];
        DF_lTxt: Text[2];
        CLE_lRec: Record "Cust. Ledger Entry";
        Year: Integer;
        Month: Integer;
        StartDate: Date;
        EndDate: Date;
        CaptionMonth_lText: Text[20];
        CaptionYear_lInt: Integer;
        currentyear, sequence : Integer;
    begin
        // AgeBy = 'Month' 

        if AgeBy = 'Month' then
            CF_lTxt := 'M';

        Clear(SD_gDteArr);
        Clear(ED_gDteArr);

        Clear(currentyear);
        currentyear := Date2DMY(Today, 3);
        sequence := 0;

        Clear(DF_lTxt);
        DF_lTxt := 'D';

        for i := 0 to 2 do begin
            //currentyear := (currentyear - i);
            Clear(SD_gDteArr);
            Clear(ED_gDteArr);
            for Month := 1 to 12 do begin
                Clear(CaptionMonth_lText);
                sequence := sequence + 1;
                case Month of
                    1:
                        begin
                            SD_gDteArr[Month] := DMY2Date(1, 1, currentyear);
                            ED_gDteArr[Month] := CalcDate('CM', SD_gDteArr[Month]);
                            CaptionMonth_lText := 'January';
                            CaptionYear_lInt := currentyear;
                        end;

                    2:
                        begin
                            SD_gDteArr[Month] := CalcDate('1' + CF_lTxt, SD_gDteArr[Month - 1]);
                            ED_gDteArr[Month] := CalcDate('CM', SD_gDteArr[Month]);
                            CaptionMonth_lText := 'February';
                            CaptionYear_lInt := currentyear;
                        end;

                    3:
                        begin
                            SD_gDteArr[Month] := CalcDate('1' + CF_lTxt, SD_gDteArr[Month - 1]);
                            ED_gDteArr[Month] := CalcDate('CM', SD_gDteArr[Month]);
                            CaptionMonth_lText := 'March';
                            CaptionYear_lInt := currentyear;
                        end;

                    4:
                        begin
                            SD_gDteArr[Month] := CalcDate('1' + CF_lTxt, SD_gDteArr[Month - 1]);
                            ED_gDteArr[Month] := CalcDate('CM', SD_gDteArr[Month]);
                            CaptionMonth_lText := 'April';
                            CaptionYear_lInt := currentyear;
                        end;

                    5:
                        begin
                            SD_gDteArr[Month] := CalcDate('1' + CF_lTxt, SD_gDteArr[Month - 1]);
                            ED_gDteArr[Month] := CalcDate('CM', SD_gDteArr[Month]);
                            CaptionMonth_lText := 'May';
                            CaptionYear_lInt := currentyear;
                        end;

                    6:
                        begin
                            SD_gDteArr[Month] := CalcDate('1' + CF_lTxt, SD_gDteArr[Month - 1]);
                            ED_gDteArr[Month] := CalcDate('CM', SD_gDteArr[Month]);
                            CaptionMonth_lText := 'June';
                            CaptionYear_lInt := currentyear;
                        end;

                    7:
                        begin
                            SD_gDteArr[Month] := CalcDate('1' + CF_lTxt, SD_gDteArr[Month - 1]);
                            ED_gDteArr[Month] := CalcDate('CM', SD_gDteArr[Month]);
                            CaptionMonth_lText := 'July';
                            CaptionYear_lInt := currentyear;
                        end;

                    8:
                        begin
                            SD_gDteArr[Month] := CalcDate('1' + CF_lTxt, SD_gDteArr[Month - 1]);
                            ED_gDteArr[Month] := CalcDate('CM', SD_gDteArr[Month]);
                            CaptionMonth_lText := 'August';
                            CaptionYear_lInt := currentyear;
                        end;

                    9:
                        begin
                            SD_gDteArr[Month] := CalcDate('1' + CF_lTxt, SD_gDteArr[Month - 1]);
                            ED_gDteArr[Month] := CalcDate('CM', SD_gDteArr[Month]);
                            CaptionMonth_lText := 'September';
                            CaptionYear_lInt := currentyear;
                        end;

                    10:
                        begin
                            SD_gDteArr[Month] := CalcDate('1' + CF_lTxt, SD_gDteArr[Month - 1]);
                            ED_gDteArr[Month] := CalcDate('CM', SD_gDteArr[Month]);
                            CaptionMonth_lText := 'Ocotber';
                            CaptionYear_lInt := currentyear;
                        end;

                    11:
                        begin
                            SD_gDteArr[Month] := CalcDate('1' + CF_lTxt, SD_gDteArr[Month - 1]);
                            ED_gDteArr[Month] := CalcDate('CM', SD_gDteArr[Month]);
                            CaptionMonth_lText := 'November';
                            CaptionYear_lInt := currentyear;
                        end;

                    12:
                        begin
                            SD_gDteArr[Month] := CalcDate('1' + CF_lTxt, SD_gDteArr[Month - 1]);
                            ED_gDteArr[Month] := CalcDate('CM', SD_gDteArr[Month]);
                            CaptionMonth_lText := 'December';
                            CaptionYear_lInt := currentyear;
                        end;

                    else
                        Message('Not');

                end;
                Clear(AgeDetails);
                AgeDetails.Init;
                AgeDetails.Source := AgeDetails.Source::Sales;
                AgeDetails."Age by" := AgeBy;
                AgeDetails.Sequence := sequence;
                AgeDetails."No." := CustomerNo_iCod;
                AgeDetails.Caption := CaptionMonth_lText;
                AgeDetails."Start Date" := SD_gDteArr[Month];
                AgeDetails."End Date" := ED_gDteArr[Month];
                AgeDetails.CaptionYear := CaptionYear_lInt;
                AgeDetails.Insert;
            end;
            currentyear := currentyear - 1;
        end;

        //VLE
        CLE_lRec.Reset;
        CLE_lRec.SetRange("Customer No.", CustomerNo_iCod);
        // VLE_lRec.SetRange(Open, true);
        CLE_lRec.SetFilter("Document Type", '=%1|%2', CLE_lRec."Document Type"::Invoice, CLE_lRec."Document Type"::"Credit Memo");
        if CLE_lRec.FindSet then begin
            repeat
                CLE_lRec.CalcFields("Amount (LCY)");

                AgeDetails.Reset;
                AgeDetails.SetRange(Source, AgeDetails.Source::Sales);
                AgeDetails.SetRange("Age by", AgeBy);
                AgeDetails.SetRange("No.", CustomerNo_iCod);
                AgeDetails.SetFilter("Start Date", '<=%1', CLE_lRec."Posting Date");
                AgeDetails.SetFilter("End Date", '>=%1', CLE_lRec."Posting Date");
                if AgeDetails.FindFirst then begin
                    AgeDetails.Amount += (CLE_lRec."Amount (LCY)" * 1);
                    AgeDetails.Modify;
                end;

            until CLE_lRec.Next = 0;
        end;
    end;
}
