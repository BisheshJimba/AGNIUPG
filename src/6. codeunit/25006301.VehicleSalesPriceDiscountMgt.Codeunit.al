codeunit 25006301 VehicleSalesPriceDiscountMgt
{
    // 11.04.2013 EDMS P8
    //   * changes due to new field in T25006374


    trigger OnRun()
    begin
    end;

    var
        SalesSetup: Record "311";
        VehAssembly: Record "25006380";
        VehAssemblyHdr: Record "25006381";
        GLSetup: Record "98";
        Currency: Record "4";
        Item: Record "27";
        ManufacturerOption: Record "25006370";
        OwnOption: Record "25006372";
        TempAssemblyPrice: Record "7002" temporary;
        TempAssemblyLineDisc: Record "7004" temporary;
        TempOptSalesPrice: Record "25006382" temporary;
        Make: Record "25006000";
        PricesInCurrency: Boolean;
        VATPerCent: Decimal;
        PricesInclVAT: Boolean;
        VATCalcType: Option "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        VATBusPostingGr: Code[10];
        VATProdPostingGr: Code[10];
        CurrencyFactor: Decimal;
        ExchRateDate: Date;
        LineDiscPerCent: Decimal;
        AllowLineDisc: Boolean;
        AllowInvDisc: Boolean;
        Text010: Label 'Prices including VAT cannot be calculated when %1 is %2.';
        FoundAssemblyPrice: Boolean;

    [Scope('Internal')]
    procedure GetOptionLineDiscount(OptionCode: Code[20]; OptionType: Option "Manufacturer Option","Own Option","Vehicle Base"; OptionSubtype: Option Option,Color,Upholstery; MakeCode: Code[20]; ModelCode: Code[20]; ModelVerNo: Code[20]; VehSerialNo: Code[20]; VehAssemblyNo: Code[20]): Decimal
    begin
        SalesSetup.GET;
        SetCurrency(SalesSetup."Def.S.Price Currency Code", 0, 0D);

        IF SalesSetup."Def.Sales Price AllowLineDisc." THEN BEGIN
            FindOptionDiscount(
              TempAssemblyLineDisc, '', '', '', '', OptionCode, '',
              WORKDATE, FALSE, MakeCode, ModelCode, ModelVerNo, OptionType, OptionSubtype);

            CalcBestAssemblyLineDisc(TempAssemblyLineDisc);
            EXIT(TempAssemblyLineDisc."Line Discount %")
        END ELSE
            EXIT(0)
    end;

    [Scope('Internal')]
    procedure GetOptionPrice(OptionCode: Code[20]; OptionType: Option "Manufacturer Option","Own Option","Vehicle Base"; OptionSubtype: Option Option,Color,Upholstery; MakeCode: Code[20]; ModelCode: Code[20]; ModelVerNo: Code[20]; VehSerialNo: Code[20]; VehAssemblyID: Code[20]): Decimal
    var
        VATPostSetup: Record "325";
        UnitPrice: Decimal;
        LineDisc: Decimal;
    begin
        SalesSetup.GET;
        SalesSetup.TESTFIELD("Def.S.Price Rounding Precision");

        IF (SalesSetup."Def.S.Price VAT Bus.Post.Grp." <> '') AND (SalesSetup."Def.S.Price VAT Prod.Post.Grp." <> '') THEN
            VATPostSetup.GET(SalesSetup."Def.S.Price VAT Bus.Post.Grp.", SalesSetup."Def.S.Price VAT Prod.Post.Grp.");

        SetCurrency(SalesSetup."Def.S.Price Currency Code", 0, 0D);
        SetVAT(SalesSetup."Def. Sales Price Include VAT", VATPostSetup."VAT %",
          VATPostSetup."VAT Calculation Type", SalesSetup."Def.S.Price VAT Bus.Post.Grp.");


        CASE OptionType OF
            OptionType::"Manufacturer Option":
                IF ManufacturerOption.GET(MakeCode, ModelCode, ModelVerNo, OptionSubtype, OptionCode) THEN BEGIN
                    FindOptionPrice(TempAssemblyPrice, '', '', '', '', OptionCode, '', WORKDATE,
                      FALSE, MakeCode, ModelCode, ModelVerNo, OptionType, OptionSubtype);
                END;
            OptionType::"Own Option":
                IF OwnOption.GET(MakeCode, ModelCode, OptionCode) THEN BEGIN
                    FindOptionPrice(TempAssemblyPrice, '', '', '', '', OptionCode, '', WORKDATE,
                      FALSE, MakeCode, ModelCode, ModelVerNo, OptionType, OptionSubtype);
                END;
            ELSE
                ERROR('This place cannot be reached! Contact programmers')
        END;

        CalcBestAssemblyPrice(TempAssemblyPrice);

        IF FoundAssemblyPrice THEN
            IF SalesSetup."Def.Sales Price Include Disc." AND TempAssemblyPrice."Allow Line Disc." AND
             SalesSetup."Def.Sales Price AllowLineDisc." THEN BEGIN
                LineDisc := GetOptionLineDiscount(OptionCode, OptionType, OptionSubtype, MakeCode, ModelCode, ModelVerNo, VehSerialNo, VehAssemblyID);
                UnitPrice := ROUND(TempAssemblyPrice."Unit Price" - TempAssemblyPrice."Unit Price" * (LineDisc / 100),
                  SalesSetup."Def.S.Price Rounding Precision");
                EXIT(UnitPrice)
            END ELSE
                EXIT(ROUND(TempAssemblyPrice."Unit Price", SalesSetup."Def.S.Price Rounding Precision"))
        ELSE
            EXIT(0)
    end;

    [Scope('Internal')]
    procedure FindAssemblyLineDisc(VehAssemblyHdr: Record "25006381"; var VehAssembly: Record "25006380")
    begin
        SetCurrency(VehAssemblyHdr."Currency Code", 0, 0D);

        AssemblyLineDiscExists(VehAssemblyHdr, VehAssembly, FALSE);
        CalcBestAssemblyLineDisc(TempAssemblyLineDisc);

        "Line Discount %" := TempAssemblyLineDisc."Line Discount %";
    end;

    [Scope('Internal')]
    procedure FindAssemblyLinePrice(VehAssemblyHdr: Record "25006381"; var VehAssembly: Record "25006380")
    begin
        SetCurrency(
  VehAssemblyHdr."Currency Code", VehAssemblyHdr."Currency Factor", VehAssemblyHdr."Exchange Date");
        SetVAT(VehAssemblyHdr."Prices Including VAT", VehAssemblyHdr."VAT %",
          VehAssemblyHdr."VAT Calculation Type", VehAssemblyHdr."VAT Bus. Posting Group");
        SetLineDisc(VehAssemblyHdr."Line Discount %", VehAssemblyHdr."Allow Line Disc.", VehAssemblyHdr."Allow Invoice Disc.");

        IF PricesInCurrency THEN
            VehAssemblyHdr.TESTFIELD("Currency Factor");

        AssemblyPriceExists(VehAssemblyHdr, VehAssembly, FALSE);
        CalcBestAssemblyPrice(TempAssemblyPrice);

        IF FoundAssemblyPrice THEN BEGIN
            "Allow Line Disc." := TempAssemblyPrice."Allow Line Disc.";
            "Sales Price" := TempAssemblyPrice."Unit Price";
            IF TempAssemblyPrice."Sales Type" = TempAssemblyPrice."Sales Type"::Campaign THEN
                "Campaign No." := TempAssemblyPrice."Sales Code";
        END;
        IF NOT "Allow Line Disc." THEN
            "Line Discount %" := 0;
    end;

    [Scope('Internal')]
    procedure AssemblyPriceExists(VehAssemblyHdr: Record "25006381"; VehAssembly: Record "25006380"; ShowAll: Boolean): Boolean
    begin
        CASE VehAssembly."Option Type" OF
            VehAssembly."Option Type"::"Manufacturer Option":
                IF ManufacturerOption.GET("Make Code", "Model Code", "Model Version No.", "Option Subtype", VehAssembly."Option Code") THEN
                    FindOptionPrice(
                      TempAssemblyPrice, VehAssemblyHdr."Bill-to Customer No.", VehAssemblyHdr."Bill-to Contact No.",
                      VehAssemblyHdr."Customer Price Group", '', VehAssembly."Option Code", VehAssemblyHdr."Currency Code", VehAssemblyHdr."Start Date",
                      ShowAll, "Make Code", "Model Code", "Model Version No.", VehAssembly."Option Type", "Option Subtype");
            VehAssembly."Option Type"::"Own Option":
                IF OwnOption.GET("Make Code", "Model Code", VehAssembly."Option Code") THEN
                    FindOptionPrice(
                      TempAssemblyPrice, VehAssemblyHdr."Bill-to Customer No.", VehAssemblyHdr."Bill-to Contact No.",
                      VehAssemblyHdr."Customer Price Group", '', VehAssembly."Option Code", VehAssemblyHdr."Currency Code", VehAssemblyHdr."Start Date",
                      ShowAll, "Make Code", "Model Code", "Model Version No.", VehAssembly."Option Type", "Option Subtype");
            VehAssembly."Option Type"::"Vehicle Base":
                IF Item.GET("Model Version No.") THEN
                    FindVehiclePrice(
                      TempAssemblyPrice, VehAssemblyHdr."Bill-to Customer No.", VehAssemblyHdr."Bill-to Contact No.",
                      VehAssemblyHdr."Customer Price Group", '', "Model Version No.",/*,"Variant Code","Unit of Measure Code",*/
                      VehAssemblyHdr."Currency Code", VehAssemblyHdr."Start Date", ShowAll, VehAssemblyHdr."Location Code",
                      VehAssemblyHdr."Ordering Price Type Code", VehAssemblyHdr."Document Profile", VehAssembly."Serial No.");
        END;
        EXIT(TempAssemblyPrice.FINDSET);

    end;

    [Scope('Internal')]
    procedure AssemblyLineDiscExists(VehAssemblyHdr: Record "25006381"; VehAssembly: Record "25006380"; ShowAll: Boolean): Boolean
    begin
        CASE VehAssembly."Option Type" OF
            VehAssembly."Option Type"::"Manufacturer Option":
                IF ManufacturerOption.GET("Make Code", "Model Code", "Model Version No.", "Option Subtype", VehAssembly."Option Code") THEN
                    FindOptionDiscount(
                      TempAssemblyLineDisc, VehAssemblyHdr."Bill-to Customer No.", VehAssemblyHdr."Bill-to Contact No.",
                      VehAssemblyHdr."Customer Disc. Group", '', VehAssembly."Option Code", VehAssemblyHdr."Currency Code",
                      VehAssemblyHdr."Start Date", ShowAll, "Make Code", "Model Code", "Model Version No.", VehAssembly."Option Type", "Option Subtype");
            VehAssembly."Option Type"::"Own Option":
                IF OwnOption.GET("Make Code", "Model Code", VehAssembly."Option Code") THEN
                    FindOptionDiscount(
                      TempAssemblyLineDisc, VehAssemblyHdr."Bill-to Customer No.", VehAssemblyHdr."Bill-to Contact No.",
                      VehAssemblyHdr."Customer Disc. Group", '', VehAssembly."Option Code", VehAssemblyHdr."Currency Code",
                      VehAssemblyHdr."Start Date", ShowAll, "Make Code", "Model Code", "Model Version No.", VehAssembly."Option Type", "Option Subtype");
            VehAssembly."Option Type"::"Vehicle Base":
                IF Item.GET("Model Version No.") THEN
                    FindVehicleDiscount(
                      TempAssemblyLineDisc, VehAssemblyHdr."Bill-to Customer No.", VehAssemblyHdr."Bill-to Contact No.",
                      VehAssemblyHdr."Customer Disc. Group", '', VehAssembly."Option Code", Item."Item Disc. Group",
                      VehAssemblyHdr."Currency Code", VehAssemblyHdr."Start Date", ShowAll, VehAssembly."Serial No.")

        END;
        EXIT(TempAssemblyLineDisc.FINDSET)
    end;

    [Scope('Internal')]
    procedure CalcBestAssemblyPrice(var SalesPrice: Record "7002")
    var
        BestSalesPrice: Record "7002";
    begin
        SalesPrice.SETFILTER("Vehicle Serial No.", '<>''''');   //21.11.2007 EDMS P3 - priority to serialNo.
        FoundAssemblyPrice := NOT SalesPrice.ISEMPTY;
        IF NOT FoundAssemblyPrice THEN BEGIN
            SalesPrice.SETRANGE("Vehicle Serial No.");
            FoundAssemblyPrice := NOT SalesPrice.ISEMPTY;
        END;
        IF FoundAssemblyPrice THEN
            REPEAT
                ConvertPriceToVAT(
                  SalesPrice."Price Includes VAT", Item."VAT Prod. Posting Group",
                  SalesPrice."VAT Bus. Posting Gr. (Price)", SalesPrice."Unit Price");
                ConvertPriceLCYToFCY(SalesPrice."Currency Code", SalesPrice."Unit Price");

                CASE TRUE OF
                    ((BestSalesPrice."Currency Code" = '') AND (SalesPrice."Currency Code" <> '')) OR
                  ((BestSalesPrice."Variant Code" = '') AND (SalesPrice."Variant Code" <> '')):
                        BestSalesPrice := SalesPrice;
                    ((BestSalesPrice."Currency Code" = '') OR (SalesPrice."Currency Code" <> '')) AND
                  ((BestSalesPrice."Variant Code" = '') OR (SalesPrice."Variant Code" <> '')):
                        IF (BestSalesPrice."Unit Price" = 0) OR
                           (CalcLineAmount(BestSalesPrice) > CalcLineAmount(SalesPrice))
                        THEN
                            BestSalesPrice := SalesPrice;
                END;
            UNTIL SalesPrice.NEXT = 0;

        // No price found in agreement
        IF BestSalesPrice."Unit Price" = 0 THEN BEGIN
            ConvertPriceToVAT(
              Item."Price Includes VAT", Item."VAT Prod. Posting Group",
              Item."VAT Bus. Posting Gr. (Price)", Item."Unit Price");
            ConvertPriceLCYToFCY('', Item."Unit Price");

            CLEAR(BestSalesPrice);
            BestSalesPrice."Unit Price" := Item."Unit Price";
            BestSalesPrice."Allow Line Disc." := AllowLineDisc;
            BestSalesPrice."Allow Invoice Disc." := AllowInvDisc;
        END;

        SalesPrice := BestSalesPrice;
    end;

    [Scope('Internal')]
    procedure CalcBestAssemblyLineDisc(var AssemblyLineDisc: Record "7004")
    var
        BestSalesLineDisc: Record "7004";
        FoundSalesLineDiscount: Boolean;
    begin
        //26.11.2007 EDMS P3 >>
        AssemblyLineDisc.SETRANGE("Sales Type", AssemblyLineDisc."Sales Type"::Assembly);
        FoundSalesLineDiscount := NOT AssemblyLineDisc.ISEMPTY;
        IF NOT FoundSalesLineDiscount THEN BEGIN
            AssemblyLineDisc.SETRANGE("Sales Type");
            AssemblyLineDisc.SETFILTER("Vehicle Serial No.", '<>''''');
            FoundSalesLineDiscount := NOT AssemblyLineDisc.ISEMPTY;
            IF NOT FoundSalesLineDiscount THEN BEGIN
                AssemblyLineDisc.SETRANGE("Vehicle Serial No.");
                FoundSalesLineDiscount := NOT AssemblyLineDisc.ISEMPTY;
            END
        END;
        //26.11.2007 EDMS P3 <<

        IF FoundSalesLineDiscount THEN
            REPEAT
                CASE TRUE OF
                    ((BestSalesLineDisc."Currency Code" = '') AND (AssemblyLineDisc."Currency Code" <> '')) OR
                  ((BestSalesLineDisc."Variant Code" = '') AND (AssemblyLineDisc."Variant Code" <> '')):
                        BestSalesLineDisc := AssemblyLineDisc;
                    ((BestSalesLineDisc."Currency Code" = '') OR (AssemblyLineDisc."Currency Code" <> '')) AND
                  ((BestSalesLineDisc."Variant Code" = '') OR (AssemblyLineDisc."Variant Code" <> '')):
                        IF BestSalesLineDisc."Line Discount %" < AssemblyLineDisc."Line Discount %" THEN
                            BestSalesLineDisc := AssemblyLineDisc;
                END;
            UNTIL AssemblyLineDisc.NEXT = 0;

        AssemblyLineDisc := BestSalesLineDisc;
    end;

    [Scope('Internal')]
    procedure FindOptionPrice(var ToSalesPrice: Record "7002"; CustNo: Code[20]; ContNo: Code[20]; CustPriceGrCode: Code[10]; CampaignNo: Code[20]; OptionNo: Code[20]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean; MakeCode: Code[20]; ModelCode: Code[20]; ModelVersionNo: Code[20]; OptionType: Integer; OptionSubtype: Integer)
    var
        FromOptionPrice: Record "25006382";
        TempTargetCampaignGr: Record "7030" temporary;
    begin
        FromOptionPrice.SETRANGE("Option Code", OptionNo);

        FromOptionPrice.SETRANGE("Make Code", MakeCode);
        FromOptionPrice.SETRANGE("Model Code", ModelCode);
        IF OptionType <> "Option Type"::"Own Option" THEN
            FromOptionPrice.SETRANGE("Model Version No.", ModelVersionNo);
        FromOptionPrice.SETRANGE("Option Type", OptionType);
        FromOptionPrice.SETRANGE("Option Subtype", OptionSubtype);

        FromOptionPrice.SETFILTER("Ending Date", '%1|>=%2', 0D, StartingDate);

        IF NOT ShowAll THEN BEGIN
            FromOptionPrice.SETFILTER("Currency Code", '%1|%2', CurrencyCode, '');
            FromOptionPrice.SETRANGE("Starting Date", 0D, StartingDate);
        END;

        ToSalesPrice.RESET;
        ToSalesPrice.DELETEALL;

        FromOptionPrice.SETRANGE("Sales Type", "Sales Type"::"All Customers");
        FromOptionPrice.SETRANGE("Sales Code");
        CopyOptionPriceToSalesPrice(FromOptionPrice, ToSalesPrice);

        IF CustNo <> '' THEN BEGIN
            FromOptionPrice.SETRANGE("Sales Type", "Sales Type"::Customer);
            FromOptionPrice.SETRANGE("Sales Code", CustNo);
            CopyOptionPriceToSalesPrice(FromOptionPrice, ToSalesPrice);
        END;

        IF CustPriceGrCode <> '' THEN BEGIN
            FromOptionPrice.SETRANGE("Sales Type", "Sales Type"::"Customer Price Group");
            FromOptionPrice.SETRANGE("Sales Code", CustPriceGrCode);
            CopyOptionPriceToSalesPrice(FromOptionPrice, ToSalesPrice);
        END;

        IF NOT ((CustNo = '') AND (ContNo = '') AND (CampaignNo = '')) THEN BEGIN
            FromOptionPrice.SETRANGE("Sales Type", "Sales Type"::Campaign);
            IF ActivatedCampaignExists(TempTargetCampaignGr, CustNo, ContNo, CampaignNo) THEN
                REPEAT
                    FromOptionPrice.SETRANGE("Sales Code", TempTargetCampaignGr."Campaign No.");
                    CopyOptionPriceToSalesPrice(FromOptionPrice, ToSalesPrice);
                UNTIL TempTargetCampaignGr.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure FindVehiclePrice(var ToSalesPrice: Record "7002"; CustNo: Code[20]; ContNo: Code[20]; CustPriceGrCode: Code[10]; CampaignNo: Code[20]; ItemNo: Code[20]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean; LocationCode: Code[10]; OrderingPriceType: Code[10]; DocumentProfile: Integer; VehSerialNo: Code[20])
    var
        FromSalesPrice: Record "7002";
        TempTargetCampaignGr: Record "7030" temporary;
    begin
        FromSalesPrice.SETRANGE("Item No.", ItemNo);
        FromSalesPrice.SETFILTER("Ending Date", '%1|>=%2', 0D, StartingDate);
        //DMS
        FromSalesPrice.SETFILTER("Location Code", '%1|%2', LocationCode, '');
        FromSalesPrice.SETFILTER("Document Profile", '%1|%2', DocumentProfile, 0);
        FromSalesPrice.SETFILTER("Ordering Price Type Code", '%1|%2', OrderingPriceType, '');
        IF VehSerialNo <> '' THEN
            FromSalesPrice.SETFILTER("Vehicle Serial No.", '%1|%2', VehSerialNo, '')
        ELSE
            FromSalesPrice.SETRANGE("Vehicle Serial No.", '');

        IF NOT ShowAll THEN BEGIN
            FromSalesPrice.SETFILTER("Currency Code", '%1|%2', CurrencyCode, '');
            FromSalesPrice.SETRANGE("Starting Date", 0D, StartingDate);
        END;

        ToSalesPrice.RESET;
        ToSalesPrice.DELETEALL;

        FromSalesPrice.SETRANGE("Sales Type", FromSalesPrice."Sales Type"::"All Customers");
        FromSalesPrice.SETRANGE("Sales Code");
        CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);

        IF CustNo <> '' THEN BEGIN
            FromSalesPrice.SETRANGE("Sales Type", FromSalesPrice."Sales Type"::Customer);
            FromSalesPrice.SETRANGE("Sales Code", CustNo);
            CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
        END;

        IF CustPriceGrCode <> '' THEN BEGIN
            FromSalesPrice.SETRANGE("Sales Type", FromSalesPrice."Sales Type"::"Customer Price Group");
            FromSalesPrice.SETRANGE("Sales Code", CustPriceGrCode);
            CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
        END;

        IF NOT ((CustNo = '') AND (ContNo = '') AND (CampaignNo = '')) THEN BEGIN
            FromSalesPrice.SETRANGE("Sales Type", FromSalesPrice."Sales Type"::Campaign);
            IF ActivatedCampaignExists(TempTargetCampaignGr, CustNo, ContNo, CampaignNo) THEN
                REPEAT
                    FromSalesPrice.SETRANGE("Sales Code", TempTargetCampaignGr."Campaign No.");
                    CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
                UNTIL TempTargetCampaignGr.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure FindVehiclePurchasePrice(var ToPurchasePrice: Record "7012"; ItemNo: Code[20]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean; OrderingPriceType: Code[10])
    var
        FromPurchasePrice: Record "7012";
        TempTargetCampaignGr: Record "7030" temporary;
    begin
        FromPurchasePrice.SETRANGE("Item No.", ItemNo);
        FromPurchasePrice.SETFILTER("Ending Date", '%1|>=%2', 0D, StartingDate);
        FromPurchasePrice.SETFILTER("Ordering Price Type Code", '%1|%2', OrderingPriceType, '');
        IF NOT ShowAll THEN BEGIN
            FromPurchasePrice.SETFILTER("Currency Code", '%1|%2', CurrencyCode, '');
            FromPurchasePrice.SETRANGE("Starting Date", 0D, StartingDate);
        END;

        ToPurchasePrice.RESET;
        ToPurchasePrice.DELETEALL;

        CopyPurchasePriceToPurchasePrice(FromPurchasePrice, ToPurchasePrice);
    end;

    [Scope('Internal')]
    procedure FindVehicleDiscount(var ToSalesLineDisc: Record "7004"; CustNo: Code[20]; ContNo: Code[20]; CustDiscGrCode: Code[10]; CampaignNo: Code[20]; ItemNo: Code[20]; ItemDiscGrCode: Code[10]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean; VehSerialNo: Code[20])
    var
        FromSalesLineDisc: Record "7004";
        TempCampaignTargetGr: Record "7030" temporary;
        InclCampaigns: Boolean;
    begin
        FromSalesLineDisc.SETFILTER("Ending Date", '%1|>=%2', 0D, StartingDate);

        IF VehSerialNo <> '' THEN
            FromSalesLineDisc.SETFILTER("Vehicle Serial No.", '%1|%2', VehSerialNo, '')
        ELSE
            FromSalesLineDisc.SETRANGE("Vehicle Serial No.", '');

        IF NOT ShowAll THEN BEGIN
            FromSalesLineDisc.SETRANGE("Starting Date", 0D, StartingDate);
            FromSalesLineDisc.SETFILTER("Currency Code", '%1|%2', CurrencyCode, '');
        END;

        ToSalesLineDisc.RESET;
        ToSalesLineDisc.DELETEALL;
        FOR FromSalesLineDisc."Sales Type" := FromSalesLineDisc."Sales Type"::Customer TO FromSalesLineDisc."Sales Type"::Campaign DO
            IF (FromSalesLineDisc."Sales Type" = FromSalesLineDisc."Sales Type"::"All Customers") OR
               ((FromSalesLineDisc."Sales Type" = FromSalesLineDisc."Sales Type"::Customer) AND (CustNo <> '')) OR
               ((FromSalesLineDisc."Sales Type" = FromSalesLineDisc."Sales Type"::"Customer Disc. Group") AND (CustDiscGrCode <> '')) OR
               ((FromSalesLineDisc."Sales Type" = FromSalesLineDisc."Sales Type"::Campaign) AND
                   NOT ((CustNo = '') AND (ContNo = '') AND (CampaignNo = '')))
            THEN BEGIN
                InclCampaigns := FALSE;

                FromSalesLineDisc.SETRANGE("Sales Type", FromSalesLineDisc."Sales Type");
                CASE FromSalesLineDisc."Sales Type" OF
                    FromSalesLineDisc."Sales Type"::"All Customers":
                        FromSalesLineDisc.SETRANGE("Sales Code");
                    FromSalesLineDisc."Sales Type"::Customer:
                        FromSalesLineDisc.SETRANGE("Sales Code", CustNo);
                    FromSalesLineDisc."Sales Type"::"Customer Disc. Group":
                        FromSalesLineDisc.SETRANGE("Sales Code", CustDiscGrCode);
                    FromSalesLineDisc."Sales Type"::Campaign:
                        BEGIN
                            InclCampaigns := ActivatedCampaignExists(TempCampaignTargetGr, CustNo, ContNo, CampaignNo);
                            FromSalesLineDisc.SETRANGE("Sales Code", TempCampaignTargetGr."Campaign No.");
                        END;
                END;

                REPEAT
                    FromSalesLineDisc.SETRANGE(Type, FromSalesLineDisc.Type::Item);
                    FromSalesLineDisc.SETRANGE(Code, ItemNo);
                    CopySalesDiscToSalesDisc(FromSalesLineDisc, ToSalesLineDisc);

                    IF ItemDiscGrCode <> '' THEN BEGIN
                        FromSalesLineDisc.SETRANGE(Type, FromSalesLineDisc.Type::"Item Disc. Group");
                        FromSalesLineDisc.SETRANGE(Code, ItemDiscGrCode);
                        CopySalesDiscToSalesDisc(FromSalesLineDisc, ToSalesLineDisc);
                    END;

                    IF InclCampaigns THEN BEGIN
                        InclCampaigns := TempCampaignTargetGr.NEXT <> 0;
                        FromSalesLineDisc.SETRANGE("Sales Code", TempCampaignTargetGr."Campaign No.");
                    END;
                UNTIL NOT InclCampaigns;
            END;
    end;

    [Scope('Internal')]
    procedure FindVehiclePurchaseDiscount(var ToPurchaseLineDisc: Record "7014"; ItemNo: Code[20]; ItemDiscGrCode: Code[10]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean)
    var
        FromPurchaseLineDisc: Record "7014";
        TempCampaignTargetGr: Record "7030" temporary;
        InclCampaigns: Boolean;
    begin
        FromPurchaseLineDisc.SETFILTER("Ending Date", '%1|>=%2', 0D, StartingDate);

        IF NOT ShowAll THEN BEGIN
            FromPurchaseLineDisc.SETRANGE("Starting Date", 0D, StartingDate);
            FromPurchaseLineDisc.SETFILTER("Currency Code", '%1|%2', CurrencyCode, '');
        END;

        ToPurchaseLineDisc.RESET;
        ToPurchaseLineDisc.DELETEALL;
        CopyPurchaseDiscToPurchaseDisc(FromPurchaseLineDisc, ToPurchaseLineDisc)
    end;

    [Scope('Internal')]
    procedure FindOptionDiscount(var ToSalesLineDisc: Record "7004"; CustNo: Code[20]; ContNo: Code[20]; CustDiscGrCode: Code[10]; CampaignNo: Code[20]; OptionCode: Code[20]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean; MakeCode: Code[20]; ModelCode: Code[20]; ModelVersionNo: Code[20]; OptionType: Integer; OptionSubtype: Integer)
    var
        FromOptionLineDisc: Record "25006376";
        TempCampaignTargetGr: Record "7030" temporary;
        InclCampaigns: Boolean;
    begin
        FromOptionLineDisc.SETFILTER("Ending Date", '%1|>=%2', 0D, StartingDate);

        IF NOT ShowAll THEN BEGIN
            FromOptionLineDisc.SETRANGE("Starting Date", 0D, StartingDate);
            FromOptionLineDisc.SETFILTER("Currency Code", '%1|%2', CurrencyCode, '');
        END;
        FromOptionLineDisc.SETRANGE("Make Code", MakeCode);
        FromOptionLineDisc.SETRANGE("Model Code", ModelCode);
        IF OptionType <> "Option Type"::"Own Option" THEN
            FromOptionLineDisc.SETRANGE("Model Version No.", ModelVersionNo);

        ToSalesLineDisc.RESET;
        ToSalesLineDisc.DELETEALL;
        FOR "Sales Type" := "Sales Type"::Customer TO "Sales Type"::Campaign DO
            IF ("Sales Type" = "Sales Type"::"All Customers") OR
               (("Sales Type" = "Sales Type"::Customer) AND (CustNo <> '')) OR
               (("Sales Type" = "Sales Type"::"Customer Disc. Group") AND (CustDiscGrCode <> '')) OR
               (("Sales Type" = "Sales Type"::Campaign) AND
                   NOT ((CustNo = '') AND (ContNo = '') AND (CampaignNo = '')))
            THEN BEGIN
                InclCampaigns := FALSE;

                FromOptionLineDisc.SETRANGE("Sales Type", "Sales Type");
                CASE "Sales Type" OF
                    "Sales Type"::"All Customers":
                        FromOptionLineDisc.SETRANGE("Sales Code");
                    "Sales Type"::Customer:
                        FromOptionLineDisc.SETRANGE("Sales Code", CustNo);
                    "Sales Type"::"Customer Disc. Group":
                        FromOptionLineDisc.SETRANGE("Sales Code", CustDiscGrCode);
                    "Sales Type"::Campaign:
                        BEGIN
                            InclCampaigns := ActivatedCampaignExists(TempCampaignTargetGr, CustNo, ContNo, CampaignNo);
                            FromOptionLineDisc.SETRANGE("Sales Code", TempCampaignTargetGr."Campaign No.");
                        END;
                END;

                REPEAT
                    FromOptionLineDisc.SETRANGE("Option Type", OptionType);
                    FromOptionLineDisc.SETRANGE("Option Subtype", OptionSubtype);
                    FromOptionLineDisc.SETRANGE("Option Code", OptionCode);
                    CopyOptionDiscToSalesDisc(FromOptionLineDisc, ToSalesLineDisc);

                    IF InclCampaigns THEN BEGIN
                        InclCampaigns := TempCampaignTargetGr.NEXT <> 0;
                        FromOptionLineDisc.SETRANGE("Sales Code", TempCampaignTargetGr."Campaign No.");
                    END;
                UNTIL NOT InclCampaigns;
            END;
    end;

    local procedure SetCurrency(CurrencyCode2: Code[10]; CurrencyFactor2: Decimal; ExchRateDate2: Date)
    begin
        PricesInCurrency := CurrencyCode2 <> '';
        IF PricesInCurrency THEN BEGIN
            Currency.GET(CurrencyCode2);
            Currency.TESTFIELD("Unit-Amount Rounding Precision");
            CurrencyFactor := CurrencyFactor2;
            ExchRateDate := ExchRateDate2;
        END ELSE
            GLSetup.GET;
    end;

    local procedure SetVAT(PriceInclVAT2: Boolean; VATPerCent2: Decimal; VATCalcType2: Option; VATBusPostingGr2: Code[10])
    begin
        PricesInclVAT := PriceInclVAT2;
        VATPerCent := VATPerCent2;
        VATCalcType := VATCalcType2;
        VATBusPostingGr := VATBusPostingGr2;
    end;

    local procedure SetLineDisc(LineDiscPerCent2: Decimal; AllowLineDisc2: Boolean; AllowInvDisc2: Boolean)
    begin
        LineDiscPerCent := LineDiscPerCent2;
        AllowLineDisc := AllowLineDisc2;
        AllowInvDisc := AllowInvDisc2;
    end;

    local procedure ConvertPriceToVAT(FromPricesInclVAT: Boolean; FromVATProdPostingGr: Code[10]; FromVATBusPostingGr: Code[10]; var UnitPrice: Decimal)
    var
        VATPostingSetup: Record "325";
    begin
        IF FromPricesInclVAT THEN BEGIN
            VATPostingSetup.GET(FromVATBusPostingGr, FromVATProdPostingGr);

            CASE VATPostingSetup."VAT Calculation Type" OF
                VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
                    VATPostingSetup."VAT %" := 0;
                VATPostingSetup."VAT Calculation Type"::"Sales Tax":
                    ERROR(
                      Text010,
                        VATPostingSetup.FIELDCAPTION("VAT Calculation Type"),
                        VATPostingSetup."VAT Calculation Type");
            END;

            CASE VATCalcType OF
                VATCalcType::"Normal VAT",
                VATCalcType::"Full VAT",
                VATCalcType::"Sales Tax":
                    BEGIN
                        IF PricesInclVAT THEN BEGIN
                            IF VATBusPostingGr <> FromVATBusPostingGr THEN
                                UnitPrice := UnitPrice * (100 + VATPerCent) / (100 + VATPostingSetup."VAT %");
                        END ELSE
                            UnitPrice := UnitPrice / (1 + VATPostingSetup."VAT %" / 100);
                    END;
                VATCalcType::"Reverse Charge VAT":
                    UnitPrice := UnitPrice / (1 + VATPostingSetup."VAT %" / 100);
            END;
        END ELSE
            IF PricesInclVAT THEN
                UnitPrice := UnitPrice * (1 + VATPerCent / 100);
    end;

    local procedure ConvertPriceLCYToFCY(CurrencyCode: Code[10]; var UnitPrice: Decimal)
    var
        CurrExchRate: Record "330";
    begin
        IF PricesInCurrency THEN BEGIN
            IF CurrencyCode = '' THEN
                UnitPrice :=
                  CurrExchRate.ExchangeAmtLCYToFCY(ExchRateDate, Currency.Code, UnitPrice, CurrencyFactor);
            UnitPrice := ROUND(UnitPrice, Currency."Unit-Amount Rounding Precision");
        END ELSE
            UnitPrice := ROUND(UnitPrice, GLSetup."Unit-Amount Rounding Precision");
    end;

    local procedure ConvertPriceFCYToLCY(CurrencyCode: Code[10]; var UnitPrice: Decimal)
    var
        CurrExchRate: Record "330";
    begin
        IF CurrencyCode <> '' THEN
            UnitPrice := CurrExchRate.ExchangeAmtFCYToLCY(ExchRateDate, CurrencyCode, UnitPrice, CurrencyFactor);
        UnitPrice := ROUND(UnitPrice, Currency."Unit-Amount Rounding Precision");
    end;

    [Scope('Internal')]
    procedure FindVehicleSalesPriceAW(var ToSalesPrice: Record "7002"; VehSerialNo: Code[20]; AssemblyID: Code[20]; ItemNo: Code[20])
    var
        SalesPrice: Decimal;
    begin
        VehAssembly.RESET;
        VehAssembly.SETRANGE("Serial No.", VehSerialNo);
        VehAssembly.SETRANGE("Assembly ID", AssemblyID);
        IF VehAssembly.FINDSET THEN BEGIN
            VehAssemblyHdr.GET(VehAssembly."Assembly ID");
            SalesPrice := 0;
            REPEAT
                SalesPrice += VehAssembly."Sales Price";
            UNTIL VehAssembly.NEXT = 0;

            ToSalesPrice.RESET;
            ToSalesPrice.DELETEALL;

            IF SalesPrice > 0 THEN BEGIN
                ToSalesPrice.INIT;
                ToSalesPrice."Sales Type" := ToSalesPrice."Sales Type"::Assembly;
                ToSalesPrice."Sales Code" := '';
                ToSalesPrice."Item No." := ItemNo;
                ToSalesPrice."Unit Price" := SalesPrice;
                ToSalesPrice."Price Includes VAT" := VehAssemblyHdr."Prices Including VAT";
                ToSalesPrice."Currency Code" := VehAssemblyHdr."Currency Code";
                ToSalesPrice."Document Profile" := ToSalesPrice."Document Profile"::"Vehicles Trade";
                ToSalesPrice."VAT Bus. Posting Gr. (Price)" := VehAssemblyHdr."VAT Bus. Posting Group";
                ToSalesPrice."Vehicle Serial No." := VehSerialNo;

                ToSalesPrice.INSERT;
            END;
        END
    end;

    [Scope('Internal')]
    procedure FindVehicleLineDiscountAW(var ToSalesLineDisc: Record "7004"; VehSerialNo: Code[20]; AssemblyID: Code[20]; ItemNo: Code[20])
    var
        SalesPrice: Decimal;
        Discount: Decimal;
    begin
        VehAssembly.RESET;
        VehAssembly.SETRANGE("Serial No.", VehSerialNo);
        VehAssembly.SETRANGE("Assembly ID", AssemblyID);
        IF VehAssembly.FINDSET THEN BEGIN
            VehAssemblyHdr.GET(VehAssembly."Assembly ID");
            SalesPrice := 0;
            Discount := 0;
            REPEAT
                SalesPrice += VehAssembly."Sales Price";
                Discount += VehAssembly."Line Discount Amount";
            UNTIL VehAssembly.NEXT = 0;
            IF SalesPrice <> 0 THEN
                Discount := Discount / SalesPrice * 100
            ELSE
                Discount := 0;

            ToSalesLineDisc.RESET;
            ToSalesLineDisc.DELETEALL;

            IF Discount > 0 THEN BEGIN
                ToSalesLineDisc.INIT;
                ToSalesLineDisc."Sales Type" := ToSalesLineDisc."Sales Type"::Assembly;
                ToSalesLineDisc."Sales Code" := '';
                ToSalesLineDisc.Type := ToSalesLineDisc.Type::Item;
                ToSalesLineDisc.Code := ItemNo;
                ToSalesLineDisc."Line Discount %" := Discount;
                ToSalesLineDisc."Document Profile" := ToSalesLineDisc."Document Profile"::"Vehicles Trade";
                ToSalesLineDisc."Currency Code" := VehAssemblyHdr."Currency Code";
                ToSalesLineDisc."Vehicle Serial No." := VehSerialNo;
                ToSalesLineDisc.INSERT;
            END;
        END
    end;

    [Scope('Internal')]
    procedure FindVehiclePurchasePriceAW(var ToPurchasePrice: Record "7012"; VehSerialNo: Code[20]; AssemblyID: Code[20]; ItemNo: Code[20])
    var
        PurchasePrice: Decimal;
    begin
        VehAssembly.RESET;
        VehAssembly.SETRANGE("Serial No.", VehSerialNo);
        VehAssembly.SETRANGE("Assembly ID", AssemblyID);
        IF VehAssembly.FINDSET THEN BEGIN
            VehAssemblyHdr.GET(VehAssembly."Assembly ID");
            PurchasePrice := 0;
            REPEAT
                PurchasePrice += VehAssembly."Direct Purchase Cost";
            UNTIL VehAssembly.NEXT = 0;

            ToPurchasePrice.RESET;
            ToPurchasePrice.DELETEALL;

            IF PurchasePrice > 0 THEN BEGIN
                ToPurchasePrice.INIT;
                ToPurchasePrice."Item No." := ItemNo;
                ToPurchasePrice."Direct Unit Cost" := PurchasePrice;
                ToPurchasePrice."Currency Code" := VehAssemblyHdr."Currency Code";
                ToPurchasePrice.INSERT;
            END;
        END
    end;

    [Scope('Internal')]
    procedure FindVehiclePurchaseDiscountAW(var ToPurchaseLineDisc: Record "7014"; VehSerialNo: Code[20]; AssemblyID: Code[20]; ItemNo: Code[20])
    var
        PurchasePrice: Decimal;
        Discount: Decimal;
    begin
        VehAssembly.RESET;
        VehAssembly.SETRANGE("Serial No.", VehSerialNo);
        VehAssembly.SETRANGE("Assembly ID", AssemblyID);
        IF VehAssembly.FINDFIRST THEN BEGIN
            VehAssemblyHdr.GET(VehAssembly."Assembly ID");
            PurchasePrice := 0;
            Discount := 0;
            REPEAT
                PurchasePrice += VehAssembly."Direct Purchase Cost";
                Discount += VehAssembly."Purchase Discount Amount";
            UNTIL VehAssembly.NEXT = 0;
            IF PurchasePrice <> 0 THEN
                Discount := Discount / PurchasePrice * 100
            ELSE
                Discount := 0;

            ToPurchaseLineDisc.RESET;
            ToPurchaseLineDisc.DELETEALL;

            IF Discount > 0 THEN BEGIN
                ToPurchaseLineDisc.INIT;
                ToPurchaseLineDisc."Item No." := ItemNo;
                ToPurchaseLineDisc."Line Discount %" := Discount;
                ToPurchaseLineDisc."Currency Code" := VehAssemblyHdr."Currency Code";
                ToPurchaseLineDisc.INSERT;
            END;
        END
    end;

    [Scope('Internal')]
    procedure ChkAssemblyHdrSalesLine(SalesLine: Record "37"; NoModify: Boolean): Boolean
    var
        SalesHeader: Record "36";
        DateCap: Text[30];
        HdrNew: Boolean;
    begin
        IF ("Vehicle Serial No." = '') THEN EXIT(FALSE);
        IF ("Vehicle Assembly ID" = '') THEN EXIT(TRUE);

        SalesHeader.GET(SalesLine."Document Type", SalesLine."Document No.");
        HdrNew := NOT VehAssemblyHdr.GET("Vehicle Assembly ID");

        IF NoModify THEN
            EXIT((VehAssemblyHdr."Currency Code" = SalesLine."Currency Code") AND
(VehAssemblyHdr."Currency Factor" = SalesHeader."Currency Factor") AND
(VehAssemblyHdr."Prices Including VAT" = SalesHeader."Prices Including VAT") AND
(VehAssemblyHdr."VAT %" = SalesLine."VAT %") AND
(VehAssemblyHdr."VAT Calculation Type" = SalesLine."VAT Calculation Type") AND
(VehAssemblyHdr."VAT Bus. Posting Group" = SalesLine."VAT Bus. Posting Group") AND
(VehAssemblyHdr."VAT Prod. Posting Group" = SalesLine."VAT Prod. Posting Group") AND
(VehAssemblyHdr."Bill-to Customer No." = SalesLine."Bill-to Customer No.") AND
(VehAssemblyHdr."Bill-to Contact No." = SalesHeader."Bill-to Contact No.") AND
(VehAssemblyHdr."Customer Price Group" = SalesLine."Customer Price Group") AND
(VehAssemblyHdr."Location Code" = SalesLine."Location Code") AND
(VehAssemblyHdr."Ordering Price Type Code" = "Ordering Price Type Code") AND
(VehAssemblyHdr."Document Profile" = "Document Profile") AND
(VehAssemblyHdr."Start Date" = SalesHeaderStartDate(SalesHeader, DateCap)) AND
(VehAssemblyHdr."Customer Disc. Group" = SalesLine."Customer Disc. Group"));

        IF HdrNew THEN BEGIN
            VehAssemblyHdr.INIT;
            VehAssemblyHdr."Assembly ID" := "Vehicle Assembly ID";
            VehAssemblyHdr.INSERT;
        END;
        IF VehAssemblyHdr."Currency Code" <> SalesLine."Currency Code" THEN
            VehAssemblyHdr."Currency Factor" := SalesHeader."Currency Factor";
        VehAssemblyHdr.VALIDATE("Currency Code", SalesLine."Currency Code");
        VehAssemblyHdr.VALIDATE("Currency Factor", SalesHeader."Currency Factor");
        VehAssemblyHdr.VALIDATE("Exchange Date", SalesHeaderExchDate(SalesHeader));
        VehAssemblyHdr.VALIDATE("Prices Including VAT", SalesHeader."Prices Including VAT");
        VehAssemblyHdr.VALIDATE("VAT %", SalesLine."VAT %");
        VehAssemblyHdr.VALIDATE("VAT Calculation Type", SalesLine."VAT Calculation Type");
        VehAssemblyHdr.VALIDATE("VAT Bus. Posting Group", SalesLine."VAT Bus. Posting Group");
        VehAssemblyHdr.VALIDATE("VAT Prod. Posting Group", SalesLine."VAT Prod. Posting Group");
        VehAssemblyHdr.VALIDATE("Bill-to Customer No.", SalesLine."Bill-to Customer No.");
        VehAssemblyHdr.VALIDATE("Bill-to Contact No.", SalesHeader."Bill-to Contact No.");
        VehAssemblyHdr.VALIDATE("Customer Price Group", SalesLine."Customer Price Group");
        VehAssemblyHdr.VALIDATE("Location Code", SalesLine."Location Code");
        VehAssemblyHdr.VALIDATE("Ordering Price Type Code", "Ordering Price Type Code");
        VehAssemblyHdr.VALIDATE("Document Profile", "Document Profile");
        VehAssemblyHdr.VALIDATE("Start Date", SalesHeaderStartDate(SalesHeader, DateCap));
        VehAssemblyHdr.VALIDATE("Customer Disc. Group", SalesLine."Customer Disc. Group");

        VehAssemblyHdr.MODIFY;
        EXIT(TRUE);  // Can be extended by confirmations
    end;

    [Scope('Internal')]
    procedure ChkAssemblyHdrPurchaseLine(PurchaseLine: Record "39"; NoModify: Boolean): Boolean
    var
        PurchaseHeader: Record "38";
        DateCap: Text[30];
        HdrNew: Boolean;
    begin
        IF ("Vehicle Serial No." = '') THEN EXIT(FALSE);
        IF ("Vehicle Assembly ID" = '') THEN EXIT(TRUE);

        PurchaseHeader.GET(PurchaseLine."Document Type", PurchaseLine."Document No.");
        HdrNew := NOT VehAssemblyHdr.GET("Vehicle Assembly ID");

        IF NoModify THEN
            EXIT((VehAssemblyHdr."Currency Code" = PurchaseLine."Currency Code") AND
(VehAssemblyHdr."Currency Factor" = PurchaseHeader."Currency Factor") AND
(VehAssemblyHdr."Prices Including VAT" = PurchaseHeader."Prices Including VAT") AND
(VehAssemblyHdr."VAT %" = PurchaseLine."VAT %") AND
(VehAssemblyHdr."VAT Calculation Type" = PurchaseLine."VAT Calculation Type") AND
(VehAssemblyHdr."VAT Bus. Posting Group" = PurchaseLine."VAT Bus. Posting Group") AND
(VehAssemblyHdr."VAT Prod. Posting Group" = PurchaseLine."VAT Prod. Posting Group") AND
(VehAssemblyHdr."Location Code" = PurchaseLine."Location Code") AND
(VehAssemblyHdr."Ordering Price Type Code" = "Ordering Price Type Code") AND
(VehAssemblyHdr."Document Profile" = "Document Profile") AND
(VehAssemblyHdr."Start Date" = PurchaseHeaderStartDate(PurchaseHeader, DateCap)));

        IF HdrNew THEN BEGIN
            VehAssemblyHdr.INIT;
            VehAssemblyHdr."Assembly ID" := "Vehicle Assembly ID";
            VehAssemblyHdr.INSERT;
        END;
        IF VehAssemblyHdr."Currency Code" <> PurchaseLine."Currency Code" THEN
            VehAssemblyHdr."Currency Factor" := PurchaseHeader."Currency Factor";
        VehAssemblyHdr.VALIDATE("Currency Code", PurchaseLine."Currency Code");
        VehAssemblyHdr.VALIDATE("Currency Factor", PurchaseHeader."Currency Factor");
        VehAssemblyHdr.VALIDATE("Exchange Date", PurchaseHeaderExchDate(PurchaseHeader));
        VehAssemblyHdr.VALIDATE("Prices Including VAT", PurchaseHeader."Prices Including VAT");
        VehAssemblyHdr.VALIDATE("VAT %", PurchaseLine."VAT %");
        VehAssemblyHdr.VALIDATE("VAT Calculation Type", PurchaseLine."VAT Calculation Type");
        VehAssemblyHdr.VALIDATE("VAT Bus. Posting Group", PurchaseLine."VAT Bus. Posting Group");
        VehAssemblyHdr.VALIDATE("VAT Prod. Posting Group", PurchaseLine."VAT Prod. Posting Group");
        VehAssemblyHdr.VALIDATE("Location Code", PurchaseLine."Location Code");
        VehAssemblyHdr.VALIDATE("Ordering Price Type Code", "Ordering Price Type Code");
        VehAssemblyHdr.VALIDATE("Document Profile", "Document Profile");
        VehAssemblyHdr.VALIDATE("Start Date", PurchaseHeaderStartDate(PurchaseHeader, DateCap));
        VehAssemblyHdr.MODIFY;
        EXIT(TRUE);  // Can be extended by confirmations
    end;

    [Scope('Internal')]
    procedure UpdAssemblyHdrField(SalesHeader: Record "36"; SalesLine: Record "37"; NonRecalcField: Integer)
    begin
        IF ("Vehicle Assembly ID" = '') OR ("Vehicle Serial No." = '') THEN EXIT;

        IF VehAssemblyHdr."Assembly ID" <> "Vehicle Assembly ID" THEN
            IF NOT VehAssemblyHdr.GET("Vehicle Assembly ID") THEN EXIT;

        CASE NonRecalcField OF
            SalesHeader.FIELDNO("Prices Including VAT"):
                VehAssemblyHdr."Prices Including VAT" := SalesHeader."Prices Including VAT";
            SalesHeader.FIELDNO("Currency Code"):
                VehAssemblyHdr."Currency Code" := SalesHeader."Currency Code";
        END;
        VehAssemblyHdr.MODIFY;
    end;

    [Scope('Internal')]
    procedure ChkAssemblyHdrPurchLine(PurchLine: Record "39"): Boolean
    var
        PurchHeader: Record "38";
        DateCap: Text[30];
        HdrNew: Boolean;
    begin
        IF ("Vehicle Assembly ID" = '') OR ("Vehicle Serial No." = '') THEN EXIT(FALSE);
        PurchHeader.GET(PurchLine."Document Type", PurchLine."Document No.");
        HdrNew := NOT VehAssemblyHdr.GET("Vehicle Assembly ID");

        IF HdrNew THEN BEGIN
            VehAssemblyHdr.INIT;
            VehAssemblyHdr."Assembly ID" := "Vehicle Assembly ID";
            VehAssemblyHdr.INSERT;
        END;
        IF VehAssemblyHdr."Currency Code" <> PurchLine."Currency Code" THEN
            VehAssemblyHdr."Currency Factor" := PurchHeader."Currency Factor";
        VehAssemblyHdr.VALIDATE("Currency Code", PurchLine."Currency Code");
        VehAssemblyHdr.VALIDATE("Currency Factor", PurchHeader."Currency Factor");
        VehAssemblyHdr.VALIDATE("Exchange Date", PurchHeaderExchDate(PurchHeader));
        VehAssemblyHdr.VALIDATE("Document Profile", "Document Profile");
        VehAssemblyHdr.MODIFY;
        EXIT(TRUE);  // Can be extended by confirmations
    end;

    local procedure CopyOptionPriceToSalesPrice(var FromOptionPrice: Record "25006382"; var ToSalesPrice: Record "7002")
    begin
        IF FromOptionPrice.FINDSET THEN
            REPEAT
                IF FromOptionPrice."Unit Price" <> 0 THEN BEGIN
                    ToSalesPrice.INIT;
                    ToSalesPrice."Item No." := FromOptionPrice."Option Code";
                    "Make Code" := FromOptionPrice."Make Code";
                    "Model Code" := FromOptionPrice."Model Code";
                    "Model Version No." := FromOptionPrice."Model Version No.";
                    ToSalesPrice."Sales Type" := FromOptionPrice."Sales Type";
                    ToSalesPrice."Sales Code" := FromOptionPrice."Sales Code";
                    ToSalesPrice."Starting Date" := FromOptionPrice."Starting Date";
                    ToSalesPrice."Ending Date" := FromOptionPrice."Ending Date";
                    ToSalesPrice."Currency Code" := FromOptionPrice."Currency Code";
                    ToSalesPrice."Price Includes VAT" := FromOptionPrice."Price Includes VAT";
                    ToSalesPrice."VAT Bus. Posting Gr. (Price)" := FromOptionPrice."VAT Bus. Posting Gr. (Price)";
                    ToSalesPrice."Unit Price" := FromOptionPrice."Unit Price";
                    ToSalesPrice.INSERT;
                END;
            UNTIL FromOptionPrice.NEXT = 0;
    end;

    local procedure CopyOptionDiscToSalesDisc(var FromOptionLineDisc: Record "25006376"; var ToSalesLineDisc: Record "7004")
    begin
        IF FromOptionLineDisc.FINDSET THEN
            REPEAT
                IF FromOptionLineDisc."Line Discount %" <> 0 THEN BEGIN
                    ToSalesLineDisc.INIT;
                    ToSalesLineDisc.Type := ToSalesLineDisc.Type::Item;
                    ToSalesLineDisc.Code := FromOptionLineDisc."Option Code";
                    ToSalesLineDisc."Sales Type" := FromOptionLineDisc."Sales Type";
                    ToSalesLineDisc."Sales Code" := FromOptionLineDisc."Sales Code";
                    ToSalesLineDisc."Starting Date" := FromOptionLineDisc."Starting Date";
                    ToSalesLineDisc."Currency Code" := FromOptionLineDisc."Currency Code";
                    ToSalesLineDisc."Line Discount %" := FromOptionLineDisc."Line Discount %";
                    ToSalesLineDisc."Ending Date" := FromOptionLineDisc."Ending Date";
                    "Make Code" := FromOptionLineDisc."Make Code";
                    "Model Code" := FromOptionLineDisc."Model Code";
                    "Model Version No." := FromOptionLineDisc."Model Version No.";
                    ToSalesLineDisc.INSERT;
                END;
            UNTIL FromOptionLineDisc.NEXT = 0;
    end;

    local procedure CopySalesPriceToSalesPrice(var FromSalesPrice: Record "7002"; var ToSalesPrice: Record "7002")
    begin
        IF FromSalesPrice.FINDSET THEN
            REPEAT
                IF FromSalesPrice."Unit Price" <> 0 THEN BEGIN
                    ToSalesPrice := FromSalesPrice;
                    ToSalesPrice.INSERT;
                END;
            UNTIL FromSalesPrice.NEXT = 0;
    end;

    local procedure CopyPurchasePriceToPurchasePrice(var FromPurchasePrice: Record "7012"; var ToPurchasePrice: Record "7012")
    begin
        IF FromPurchasePrice.FINDSET THEN
            REPEAT
                IF FromPurchasePrice."Direct Unit Cost" <> 0 THEN BEGIN
                    ToPurchasePrice := FromPurchasePrice;
                    ToPurchasePrice.INSERT;
                END;
            UNTIL FromPurchasePrice.NEXT = 0;
    end;

    local procedure CopySalesDiscToSalesDisc(var FromSalesLineDisc: Record "7004"; var ToSalesLineDisc: Record "7004")
    begin
        IF FromSalesLineDisc.FINDSET THEN
            REPEAT
                IF FromSalesLineDisc."Line Discount %" <> 0 THEN BEGIN
                    ToSalesLineDisc := FromSalesLineDisc;
                    ToSalesLineDisc.INSERT;
                END;
            UNTIL FromSalesLineDisc.NEXT = 0;
    end;

    local procedure CopyPurchaseDiscToPurchaseDisc(var FromPurchaseLineDisc: Record "7014"; var ToPurchaseLineDisc: Record "7014")
    begin
        IF FromPurchaseLineDisc.FINDSET THEN
            REPEAT
                IF FromPurchaseLineDisc."Line Discount %" <> 0 THEN BEGIN
                    ToPurchaseLineDisc := FromPurchaseLineDisc;
                    ToPurchaseLineDisc.INSERT;
                END;
            UNTIL FromPurchaseLineDisc.NEXT = 0;
    end;

    local procedure ActivatedCampaignExists(var ToCampaignTargetGr: Record "7030"; CustNo: Code[20]; ContNo: Code[20]; CampaignNo: Code[20]): Boolean
    var
        FromCampaignTargetGr: Record "7030";
        Cont: Record "5050";
        recCampaign: Record "5071";
    begin
        ToCampaignTargetGr.RESET;
        ToCampaignTargetGr.DELETEALL;

        IF CampaignNo <> '' THEN BEGIN
            ToCampaignTargetGr."Campaign No." := CampaignNo;
            ToCampaignTargetGr.INSERT;
        END ELSE BEGIN
            FromCampaignTargetGr.SETRANGE(Type, FromCampaignTargetGr.Type::Customer);
            FromCampaignTargetGr.SETRANGE("No.", CustNo);
            IF FromCampaignTargetGr.FINDSET THEN
                REPEAT
                    ToCampaignTargetGr := FromCampaignTargetGr;
                    ToCampaignTargetGr.INSERT;
                UNTIL FromCampaignTargetGr.NEXT = 0
            ELSE BEGIN
                IF Cont.GET(ContNo) THEN BEGIN
                    FromCampaignTargetGr.SETRANGE(Type, FromCampaignTargetGr.Type::Contact);
                    FromCampaignTargetGr.SETRANGE("No.", Cont."Company No.");
                    IF FromCampaignTargetGr.FINDSET THEN
                        REPEAT
                            ToCampaignTargetGr := FromCampaignTargetGr;
                            ToCampaignTargetGr.INSERT;
                        UNTIL FromCampaignTargetGr.NEXT = 0;
                END;
            END;
            //DMS
            recCampaign.RESET;
            recCampaign.SETCURRENTKEY("Activated (Sales)");
            recCampaign.SETRANGE("Activated (Sales)", TRUE);
            recCampaign.SETRANGE("Campaign Applies to All");
            IF recCampaign.FINDSET THEN
                REPEAT
                    ToCampaignTargetGr.INIT;
                    ToCampaignTargetGr.Type := ToCampaignTargetGr.Type::Customer;
                    ToCampaignTargetGr."No." := CustNo;
                    ToCampaignTargetGr."Campaign No." := recCampaign."No.";
                    IF ToCampaignTargetGr.INSERT THEN;
                UNTIL recCampaign.NEXT = 0;

        END;
        EXIT(ToCampaignTargetGr.FINDSET);
    end;

    local procedure SalesHeaderExchDate(SalesHeader: Record "36"): Date
    begin
        IF (SalesHeader."Document Type" IN [SalesHeader."Document Type"::"Blanket Order", SalesHeader."Document Type"::Quote]) AND
   (SalesHeader."Posting Date" = 0D)
THEN
            EXIT(WORKDATE);
        EXIT(SalesHeader."Posting Date");
    end;

    local procedure SalesHeaderStartDate(SalesHeader: Record "36"; var DateCaption: Text[30]): Date
    begin
        IF SalesHeader."Document Type" IN [SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::"Credit Memo"] THEN BEGIN
            DateCaption := SalesHeader.FIELDCAPTION("Posting Date");
            EXIT(SalesHeader."Posting Date")
        END ELSE BEGIN
            DateCaption := SalesHeader.FIELDCAPTION("Order Date");
            EXIT(SalesHeader."Order Date");
        END;
    end;

    local procedure PurchaseHeaderExchDate(PurchaseHeader: Record "38"): Date
    begin
        IF (PurchaseHeader."Document Type" IN [PurchaseHeader."Document Type"::"Blanket Order", PurchaseHeader."Document Type"::Quote]) AND
   (PurchaseHeader."Posting Date" = 0D)
THEN
            EXIT(WORKDATE);
        EXIT(PurchaseHeader."Posting Date");
    end;

    local procedure PurchaseHeaderStartDate(PurchaseHeader: Record "38"; var DateCaption: Text[30]): Date
    begin
        IF PurchaseHeader."Document Type" IN [PurchaseHeader."Document Type"::Invoice, PurchaseHeader."Document Type"::"Credit Memo"] THEN BEGIN
            DateCaption := PurchaseHeader.FIELDCAPTION("Posting Date");
            EXIT(PurchaseHeader."Posting Date")
        END ELSE BEGIN
            DateCaption := PurchaseHeader.FIELDCAPTION("Order Date");
            EXIT(PurchaseHeader."Order Date");
        END;
    end;

    [Scope('Internal')]
    procedure UpdateSalesLineAmounts(var NewVehAssembly: Record "25006380")
    var
        SalesLine: Record "37";
        SalesHeader: Record "36";
    begin
        //Izmainam pârdo³anas rindâs
        SalesLine.RESET;
        SalesLine.SETCURRENTKEY(Type, "Line Type", "Vehicle Serial No.");
        SalesLine.SETRANGE("Line Type", SalesLine."Line Type"::Vehicle);
        SalesLine.SETRANGE("Vehicle Serial No.", NewVehAssembly."Serial No.");
        SalesLine.SETRANGE("Vehicle Assembly ID", NewVehAssembly."Assembly ID");
        IF SalesLine.FINDSET(TRUE, FALSE) THEN BEGIN
            SalesHeader.GET(SalesLine."Document Type", SalesLine."Document No.");
            SalesHeader.TESTFIELD(Status, SalesHeader.Status::Open);

            REPEAT
                SalesLine.UpdateUnitPrice2;
                SalesLine.MODIFY;
            UNTIL SalesLine.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure UpdatePurchLineAmounts(var NewVehAssembly: Record "25006380")
    var
        PurchaseLine: Record "39";
        PurchaseHeader: Record "38";
    begin
        //Izmainam iepirkumu rindâs
        PurchaseLine.RESET;
        PurchaseLine.SETCURRENTKEY(Type, "Line Type", "Vehicle Serial No.");
        PurchaseLine.SETRANGE("Line Type", PurchaseLine."Line Type"::Vehicle);
        PurchaseLine.SETRANGE("Vehicle Serial No.", NewVehAssembly."Serial No.");
        PurchaseLine.SETRANGE("Vehicle Assembly ID", NewVehAssembly."Assembly ID");
        IF PurchaseLine.FINDSET(TRUE, FALSE) THEN BEGIN
            PurchaseHeader.GET(PurchaseLine."Document Type", PurchaseLine."Document No.");
            PurchaseHeader.TESTFIELD(Status, PurchaseHeader.Status::Open);

            REPEAT
                PurchaseLine.UpdateUnitPrice2;
                PurchaseLine.MODIFY;
            UNTIL PurchaseLine.NEXT = 0;
        END;
    end;

    local procedure CalcLineAmount(SalesPrice: Record "7002"): Decimal
    begin
        IF SalesPrice."Allow Line Disc." THEN
            EXIT(SalesPrice."Unit Price" * (1 - LineDiscPerCent / 100));
        EXIT(SalesPrice."Unit Price");
    end;

    local procedure PurchHeaderExchDate(PurchHeader: Record "38"): Date
    begin
        IF (PurchHeader."Document Type" IN [PurchHeader."Document Type"::"Blanket Order", PurchHeader."Document Type"::Quote]) AND
   (PurchHeader."Posting Date" = 0D)
THEN
            EXIT(WORKDATE);
        EXIT(PurchHeader."Posting Date");
    end;

    [Scope('Internal')]
    procedure ChkAssemblyHdrReqLine(ReqLine: Record "246"): Boolean
    var
        DateCap: Text[30];
        HdrNew: Boolean;
    begin
        IF ("Vehicle Assembly ID" = '') OR ("Vehicle Serial No." = '') THEN EXIT(FALSE);
        HdrNew := NOT VehAssemblyHdr.GET("Vehicle Assembly ID");

        IF HdrNew THEN BEGIN
            VehAssemblyHdr.INIT;
            VehAssemblyHdr."Assembly ID" := "Vehicle Assembly ID";
            VehAssemblyHdr.INSERT;
        END;
        IF VehAssemblyHdr."Currency Code" <> ReqLine."Currency Code" THEN
            VehAssemblyHdr."Currency Factor" := ReqLine."Currency Factor";
        VehAssemblyHdr.VALIDATE("Currency Code", ReqLine."Currency Code");
        VehAssemblyHdr.VALIDATE("Currency Factor", ReqLine."Currency Factor");
        VehAssemblyHdr.VALIDATE("Exchange Date", WORKDATE);
        VehAssemblyHdr.VALIDATE("Document Profile", "Document Profile");
        VehAssemblyHdr.MODIFY;
        EXIT(TRUE);  // Can be extended by confirmations
    end;

    [Scope('Internal')]
    procedure ChkAssemblyHdrTransferLine(TransferLine: Record "5741"): Boolean
    var
        DateCap: Text[30];
        HdrNew: Boolean;
    begin
        IF ("Vehicle Assembly ID" = '') OR ("Vehicle Serial No." = '') THEN EXIT(FALSE);
        HdrNew := NOT VehAssemblyHdr.GET("Vehicle Assembly ID");

        IF HdrNew THEN BEGIN
            VehAssemblyHdr.INIT;
            VehAssemblyHdr."Assembly ID" := "Vehicle Assembly ID";
            VehAssemblyHdr.INSERT;
        END;
        VehAssemblyHdr.VALIDATE("Document Profile", "Document Profile");
        VehAssemblyHdr.MODIFY;
        EXIT(TRUE);  // Can be extended by confirmations
    end;

    [Scope('Internal')]
    procedure FindAssemblyLinePurchasePrice(VehAssemblyHdr: Record "25006381"; var VehAssembly: Record "25006380")
    var
        OptionPurchasePrice: Record "25006040";
        PurchasePrice: Record "7012";
        CurrencyCode: Code[10];
        CurrExchRate: Record "330";
        CurrentExchFactor: Decimal;
    begin
        SetVAT(VehAssemblyHdr."Prices Including VAT", VehAssemblyHdr."VAT %",
  VehAssemblyHdr."VAT Calculation Type", VehAssemblyHdr."VAT Bus. Posting Group");
        SetLineDisc(VehAssemblyHdr."Line Discount %", VehAssemblyHdr."Allow Line Disc.", VehAssemblyHdr."Allow Invoice Disc.");

        IF PricesInCurrency THEN
            VehAssemblyHdr.TESTFIELD("Currency Factor");

        CASE VehAssembly."Option Type" OF
            VehAssembly."Option Type"::"Manufacturer Option":
                WITH OptionPurchasePrice DO BEGIN
                    OptionPurchasePrice.SETRANGE("Option Code", VehAssembly."Option Code");
                    OptionPurchasePrice.SETRANGE("Make Code", VehAssembly."Make Code");
                    OptionPurchasePrice.SETRANGE("Model Code", VehAssembly."Model Code");
                    IF VehAssembly."Option Type" <> "Option Type"::"Own Option" THEN
                        OptionPurchasePrice.SETRANGE("Model Version No.", VehAssembly."Model Version No.");
                    OptionPurchasePrice.SETRANGE("Option Type", VehAssembly."Option Type");
                    OptionPurchasePrice.SETRANGE("Option Subtype", VehAssembly."Option Subtype");
                    OptionPurchasePrice.SETRANGE("Starting Date", 0D, VehAssemblyHdr."Start Date");
                    OptionPurchasePrice.SETFILTER("Ending Date", '%1|>=%2', 0D, VehAssemblyHdr."Start Date");
                    //SETFILTER("Currency Code",'%1|%2',VehAssemblyHdr."Currency Code",'');
                    IF OptionPurchasePrice.FINDLAST THEN BEGIN
                        CurrentExchFactor := CurrExchRate.GetCurrentCurrencyFactor(OptionPurchasePrice."Currency Code");
                        SetCurrency(OptionPurchasePrice."Currency Code", CurrentExchFactor, VehAssemblyHdr."Exchange Date");
                        ConvertPriceFCYToLCY(OptionPurchasePrice."Currency Code", "Direct Unit Cost");

                        SetCurrency(VehAssemblyHdr."Currency Code", VehAssemblyHdr."Currency Factor", VehAssemblyHdr."Exchange Date");
                        ConvertPriceLCYToFCY('', "Direct Unit Cost");
                        VehAssembly."Direct Purchase Cost" := "Direct Unit Cost";
                    END;
                END;
            VehAssembly."Option Type"::"Own Option":
                WITH OptionPurchasePrice DO BEGIN
                    OptionPurchasePrice.SETRANGE("Option Code", VehAssembly."Option Code");
                    OptionPurchasePrice.SETRANGE("Make Code", VehAssembly."Make Code");
                    OptionPurchasePrice.SETRANGE("Model Code", VehAssembly."Model Code");
                    IF VehAssembly."Option Type" <> "Option Type"::"Own Option" THEN
                        OptionPurchasePrice.SETRANGE("Model Version No.", VehAssembly."Model Version No.");
                    OptionPurchasePrice.SETRANGE("Option Type", VehAssembly."Option Type");
                    OptionPurchasePrice.SETRANGE("Option Subtype", VehAssembly."Option Subtype");
                    OptionPurchasePrice.SETRANGE("Starting Date", 0D, VehAssemblyHdr."Start Date");
                    OptionPurchasePrice.SETFILTER("Ending Date", '%1|>=%2', 0D, VehAssemblyHdr."Start Date");
                    //SETFILTER("Currency Code",'%1|%2',VehAssemblyHdr."Currency Code",'');
                    IF OptionPurchasePrice.FINDLAST THEN BEGIN
                        CurrentExchFactor := CurrExchRate.GetCurrentCurrencyFactor(OptionPurchasePrice."Currency Code");
                        SetCurrency(OptionPurchasePrice."Currency Code", CurrentExchFactor, VehAssemblyHdr."Exchange Date");
                        ConvertPriceFCYToLCY(OptionPurchasePrice."Currency Code", "Direct Unit Cost");

                        SetCurrency(VehAssemblyHdr."Currency Code", VehAssemblyHdr."Currency Factor", VehAssemblyHdr."Exchange Date");
                        ConvertPriceLCYToFCY('', "Direct Unit Cost");
                        VehAssembly."Direct Purchase Cost" := "Direct Unit Cost";
                    END;
                END;
            VehAssembly."Option Type"::"Vehicle Base":
                WITH PurchasePrice DO BEGIN
                    PurchasePrice.SETRANGE("Item No.", VehAssembly."Model Version No.");
                    PurchasePrice.SETRANGE("Starting Date", 0D, VehAssemblyHdr."Start Date");
                    PurchasePrice.SETFILTER("Ending Date", '%1|>=%2', 0D, VehAssemblyHdr."Start Date");
                    PurchasePrice.SETFILTER("Ordering Price Type Code", '%1|%2', VehAssemblyHdr."Ordering Price Type Code", '');
                    //SETFILTER("Currency Code",'%1|%2',CurrencyCode,'');
                    IF PurchasePrice.FINDLAST THEN BEGIN
                        CurrentExchFactor := CurrExchRate.GetCurrentCurrencyFactor(OptionPurchasePrice."Currency Code");
                        SetCurrency(OptionPurchasePrice."Currency Code", CurrentExchFactor, VehAssemblyHdr."Exchange Date");
                        ConvertPriceFCYToLCY(OptionPurchasePrice."Currency Code", PurchasePrice."Direct Unit Cost");

                        SetCurrency(VehAssemblyHdr."Currency Code", VehAssemblyHdr."Currency Factor", VehAssemblyHdr."Exchange Date");
                        ConvertPriceLCYToFCY('', PurchasePrice."Direct Unit Cost");
                        VehAssembly."Direct Purchase Cost" := PurchasePrice."Direct Unit Cost";
                    END;
                END;
        END;
    end;

    [Scope('Internal')]
    procedure FindAssemblyLinePurchaseDisc(VehAssemblyHdr: Record "25006381"; var VehAssembly: Record "25006380")
    var
        OptionPurchaseDiscount: Record "25006039";
        PurchaseLineDiscount: Record "7014";
        CurrencyCode: Code[10];
    begin
        SetCurrency(VehAssemblyHdr."Currency Code", 0, 0D);
        CASE VehAssembly."Option Type" OF
            VehAssembly."Option Type"::"Manufacturer Option":
                WITH OptionPurchaseDiscount DO BEGIN
                    OptionPurchaseDiscount.SETRANGE("Starting Date", 0D, VehAssemblyHdr."Start Date");
                    OptionPurchaseDiscount.SETFILTER("Ending Date", '%1|>=%2', 0D, VehAssemblyHdr."Start Date");
                    //SETFILTER("Currency Code",'%1|%2',VehAssemblyHdr."Currency Code",'');

                    OptionPurchaseDiscount.SETRANGE("Make Code", VehAssembly."Make Code");
                    OptionPurchaseDiscount.SETRANGE("Model Code", VehAssembly."Model Code");

                    IF VehAssembly."Option Type" <> "Option Type"::"Own Option" THEN
                        OptionPurchaseDiscount.SETRANGE("Model Version No.", VehAssembly."Model Version No.");

                    OptionPurchaseDiscount.SETRANGE("Option Type", VehAssembly."Option Type");
                    OptionPurchaseDiscount.SETRANGE("Option Subtype", VehAssembly."Option Subtype");
                    OptionPurchaseDiscount.SETRANGE("Option Code", VehAssembly."Option Code");
                    IF OptionPurchaseDiscount.FINDLAST THEN BEGIN
                        VehAssembly."Purchase Discount %" := "Line Discount %";
                    END;
                END;
            VehAssembly."Option Type"::"Own Option":
                WITH OptionPurchaseDiscount DO BEGIN
                    OptionPurchaseDiscount.SETRANGE("Starting Date", 0D, VehAssemblyHdr."Start Date");
                    OptionPurchaseDiscount.SETFILTER("Ending Date", '%1|>=%2', 0D, VehAssemblyHdr."Start Date");
                    //SETFILTER("Currency Code",'%1|%2',VehAssemblyHdr."Currency Code",'');

                    OptionPurchaseDiscount.SETRANGE("Make Code", VehAssembly."Make Code");
                    OptionPurchaseDiscount.SETRANGE("Model Code", VehAssembly."Model Code");

                    IF VehAssembly."Option Type" <> "Option Type"::"Own Option" THEN
                        OptionPurchaseDiscount.SETRANGE("Model Version No.", VehAssembly."Model Version No.");

                    OptionPurchaseDiscount.SETRANGE("Option Type", VehAssembly."Option Type");
                    OptionPurchaseDiscount.SETRANGE("Option Subtype", VehAssembly."Option Subtype");
                    OptionPurchaseDiscount.SETRANGE("Option Code", VehAssembly."Option Code");
                    IF OptionPurchaseDiscount.FINDLAST THEN BEGIN
                        VehAssembly."Purchase Discount %" := "Line Discount %";
                    END;
                END;
            VehAssembly."Option Type"::"Vehicle Base":
                WITH PurchaseLineDiscount DO BEGIN
                    PurchaseLineDiscount.SETRANGE("Item No.", VehAssembly."Model Version No.");
                    PurchaseLineDiscount.SETRANGE("Starting Date", 0D, VehAssemblyHdr."Start Date");
                    PurchaseLineDiscount.SETFILTER("Ending Date", '%1|>=%2', 0D, VehAssemblyHdr."Start Date");
                    //SETFILTER("Currency Code",'%1|%2',CurrencyCode,'');
                    IF PurchaseLineDiscount.FINDLAST THEN BEGIN
                        VehAssembly."Purchase Discount %" := PurchaseLineDiscount."Line Discount %";
                    END;
                END;
        END;
    end;
}

