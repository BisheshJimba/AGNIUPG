table 33020434 "Dealer Item Ledger Entry"
{
    Caption = 'Dealer Item Ledger Entry';
    DrillDownPageID = 38;
    LookupPageID = 38;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(4; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption,Output, ,Assembly Consumption,Assembly Output';
            OptionMembers = Purchase,Sale,"Positive Adjmt.","Negative Adjmt.",Transfer,Consumption,Output," ","Assembly Consumption","Assembly Output";
        }
        field(5; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = IF (Source Type=CONST(Customer)) Customer
                            ELSE IF (Source Type=CONST(Vendor)) Vendor
                            ELSE IF (Source Type=CONST(Item)) Item;
        }
        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(7; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(8; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(12; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(13; "Remaining Quantity"; Decimal)
        {
            Caption = 'Remaining Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(14; "Invoiced Quantity"; Decimal)
        {
            Caption = 'Invoiced Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(28; "Applies-to Entry"; Integer)
        {
            Caption = 'Applies-to Entry';
        }
        field(29; Open; Boolean)
        {
            Caption = 'Open';
        }
        field(33; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(1));
        }
        field(34; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(2));
        }
        field(36; Positive; Boolean)
        {
            Caption = 'Positive';
        }
        field(41; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionCaption = ' ,Customer,Vendor,Item';
            OptionMembers = " ",Customer,Vendor,Item;
        }
        field(47; "Drop Shipment"; Boolean)
        {
            AccessByPermission = TableData 223 = R;
            Caption = 'Drop Shipment';
        }
        field(50; "Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
            TableRelation = "Transaction Type";
        }
        field(51; "Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
            TableRelation = "Transport Method";
        }
        field(52; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = Country/Region;
        }
        field(59;"Entry/Exit Point";Code[10])
        {
            Caption = 'Entry/Exit Point';
            TableRelation = "Entry/Exit Point";
        }
        field(60;"Document Date";Date)
        {
            Caption = 'Document Date';
        }
        field(61;"External Document No.";Code[35])
        {
            Caption = 'External Document No.';
        }
        field(62;"Area";Code[10])
        {
            Caption = 'Area';
            TableRelation = Area;
        }
        field(63;"Transaction Specification";Code[10])
        {
            Caption = 'Transaction Specification';
            TableRelation = "Transaction Specification";
        }
        field(64;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(70;"Reserved Quantity";Decimal)
        {
            AccessByPermission = TableData 120=R;
            CalcFormula = Sum("Reservation Entry"."Quantity (Base)" WHERE (Source ID=CONST(),
                                                                           Source Ref. No.=FIELD(Entry No.),
                                                                           Source Type=CONST(32),
                                                                           Source Subtype=CONST(0),
                                                                           Source Batch Name=CONST(),
                                                                           Source Prod. Order Line=CONST(0),
                                                                           Reservation Status=CONST(Reservation)));
            Caption = 'Reserved Quantity';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(79;"Document Type";Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Sales Shipment,Sales Invoice,Sales Return Receipt,Sales Credit Memo,Purchase Receipt,Purchase Invoice,Purchase Return Shipment,Purchase Credit Memo,Transfer Shipment,Transfer Receipt,Service Shipment,Service Invoice,Service Credit Memo,Posted Assembly';
            OptionMembers = " ","Sales Shipment","Sales Invoice","Sales Return Receipt","Sales Credit Memo","Purchase Receipt","Purchase Invoice","Purchase Return Shipment","Purchase Credit Memo","Transfer Shipment","Transfer Receipt","Service Shipment","Service Invoice","Service Credit Memo","Posted Assembly";
        }
        field(80;"Document Line No.";Integer)
        {
            Caption = 'Document Line No.';
        }
        field(90;"Order Type";Option)
        {
            Caption = 'Order Type';
            Editable = false;
            OptionCaption = ' ,Production,Transfer,Service,Assembly';
            OptionMembers = " ",Production,Transfer,Service,Assembly;
        }
        field(91;"Order No.";Code[20])
        {
            Caption = 'Order No.';
            Editable = false;
        }
        field(92;"Order Line No.";Integer)
        {
            Caption = 'Order Line No.';
            Editable = false;
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(904;"Assemble to Order";Boolean)
        {
            AccessByPermission = TableData 90=R;
            Caption = 'Assemble to Order';
        }
        field(1000;"Job No.";Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job.No.;
        }
        field(1001;"Job Task No.";Code[20])
        {
            Caption = 'Job Task No.';
            TableRelation = "Job Task"."Job Task No." WHERE (Job No.=FIELD(Job No.));
        }
        field(1002;"Job Purchase";Boolean)
        {
            Caption = 'Job Purchase';
        }
        field(5402;"Variant Code";Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE (Item No.=FIELD(Item No.));
        }
        field(5404;"Qty. per Unit of Measure";Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0:5;
        }
        field(5407;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE (Item No.=FIELD(Item No.));
        }
        field(5408;"Derived from Blanket Order";Boolean)
        {
            Caption = 'Derived from Blanket Order';
        }
        field(5700;"Cross-Reference No.";Code[20])
        {
            Caption = 'Cross-Reference No.';
        }
        field(5701;"Originally Ordered No.";Code[20])
        {
            AccessByPermission = TableData 5715=R;
            Caption = 'Originally Ordered No.';
            TableRelation = Item;
        }
        field(5702;"Originally Ordered Var. Code";Code[10])
        {
            AccessByPermission = TableData 5715=R;
            Caption = 'Originally Ordered Var. Code';
            TableRelation = "Item Variant".Code WHERE (Item No.=FIELD(Originally Ordered No.));
        }
        field(5703;"Out-of-Stock Substitution";Boolean)
        {
            Caption = 'Out-of-Stock Substitution';
        }
        field(5704;"Item Category Code";Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(5705;Nonstock;Boolean)
        {
            Caption = 'Nonstock';
        }
        field(5706;"Purchasing Code";Code[10])
        {
            Caption = 'Purchasing Code';
            TableRelation = Purchasing;
        }
        field(5707;"Product Group Code";Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "Product Group".Code WHERE (Item Category Code=FIELD(Item Category Code));
        }
        field(5800;"Completely Invoiced";Boolean)
        {
            Caption = 'Completely Invoiced';
        }
        field(5801;"Last Invoice Date";Date)
        {
            Caption = 'Last Invoice Date';
        }
        field(5802;"Applied Entry to Adjust";Boolean)
        {
            Caption = 'Applied Entry to Adjust';
        }
        field(5803;"Cost Amount (Expected)";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Cost Amount (Expected)';
            Editable = false;
            FieldClass = Normal;
        }
        field(5804;"Cost Amount (Actual)";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Cost Amount (Actual)';
            Editable = false;
            FieldClass = Normal;
        }
        field(5805;"Cost Amount (Non-Invtbl.)";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Cost Amount (Non-Invtbl.)';
            Editable = false;
            FieldClass = Normal;
        }
        field(5806;"Cost Amount (Expected) (ACY)";Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Cost Amount (Expected) (ACY)';
            Editable = false;
            FieldClass = Normal;
        }
        field(5807;"Cost Amount (Actual) (ACY)";Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Cost Amount (Actual) (ACY)';
            Editable = false;
            FieldClass = Normal;
        }
        field(5808;"Cost Amount (Non-Invtbl.)(ACY)";Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Cost Amount (Non-Invtbl.)(ACY)';
            Editable = false;
            FieldClass = Normal;
        }
        field(5813;"Purchase Amount (Expected)";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Purchase Amount (Expected)';
            Editable = false;
            FieldClass = Normal;
        }
        field(5814;"Purchase Amount (Actual)";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Purchase Amount (Actual)';
            Editable = false;
            FieldClass = Normal;
        }
        field(5815;"Sales Amount (Expected)";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Sales Amount (Expected)';
            Editable = false;
            FieldClass = Normal;
        }
        field(5816;"Sales Amount (Actual)";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Sales Amount (Actual)';
            Editable = false;
            FieldClass = Normal;
        }
        field(5817;Correction;Boolean)
        {
            Caption = 'Correction';
        }
        field(5818;"Shipped Qty. Not Returned";Decimal)
        {
            AccessByPermission = TableData 36=R;
            Caption = 'Shipped Qty. Not Returned';
            DecimalPlaces = 0:5;
        }
        field(5833;"Prod. Order Comp. Line No.";Integer)
        {
            AccessByPermission = TableData 5405=R;
            Caption = 'Prod. Order Comp. Line No.';
        }
        field(6500;"Serial No.";Code[20])
        {
            Caption = 'Serial No.';

            trigger OnLookup()
            begin
                ItemTrackingMgt.LookupLotSerialNoInfo("Item No.","Variant Code",0,"Serial No.");
            end;
        }
        field(6501;"Lot No.";Code[20])
        {
            Caption = 'Lot No.';

            trigger OnLookup()
            begin
                ItemTrackingMgt.LookupLotSerialNoInfo("Item No.","Variant Code",1,"Lot No.");
            end;
        }
        field(6502;"Warranty Date";Date)
        {
            Caption = 'Warranty Date';
        }
        field(6503;"Expiration Date";Date)
        {
            Caption = 'Expiration Date';
        }
        field(6510;"Item Tracking";Option)
        {
            Caption = 'Item Tracking';
            Editable = false;
            OptionCaption = 'None,Lot No.,Lot and Serial No.,Serial No.';
            OptionMembers = "None","Lot No.","Lot and Serial No.","Serial No.";
        }
        field(6602;"Return Reason Code";Code[10])
        {
            Caption = 'Return Reason Code';
            TableRelation = "Return Reason";
        }
        field(50003;"Purchase Consignment No.";Code[20])
        {
            Description = 'VAT1.00';
        }
        field(50011;"Make Code";Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(50012;"Model Code";Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code WHERE (Make Code=FIELD(Make Code));
        }
        field(50014;"Service Order No.";Code[20])
        {
        }
        field(50015;"Reserved From Service";Boolean)
        {
        }
        field(50016;"Service Order Line No";Integer)
        {
        }
        field(50017;"Service Item No.";Code[20])
        {
            TableRelation = "Service Item";
        }
        field(50021;"Package No.";Code[20])
        {
        }
        field(50401;"Document Profile";Option)
        {
            Caption = 'Document Profile';
            Description = 'NP15.1001';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = " ","Spare Parts Trade","Vehicles Trade",Service;
        }
        field(50501;PragyapanPatra;Code[100])
        {
            Description = 'NP15.1001';
        }
        field(50502;"Syakar No.";Code[20])
        {
        }
        field(50503;"Engine No.";Code[20])
        {
        }
        field(50504;"Veh. Registration No.";Code[20])
        {
        }
        field(50505;"VIN (Normal)";Code[20])
        {
            TableRelation = "Service Item";
        }
        field(50506;"Supplier Code";Code[10])
        {
        }
        field(50507;"FMS Code";Code[10])
        {
        }
        field(50701;"Sales Back Order No.";Code[20])
        {
        }
        field(50702;"Sales Back Order Line No.";Integer)
        {
        }
        field(59000;"Parent Lot No.";Code[30])
        {
        }
        field(59001;"QR Code Text";Code[250])
        {
        }
        field(59002;"QR Code Blob";BLOB)
        {
            SubType = Bitmap;
        }
        field(59003;"QR Code Printed";Boolean)
        {
        }
        field(59004;"QR No. of Times Printed";Integer)
        {
        }
        field(59005;"QR Status";Option)
        {
            OptionCaption = ' ,Verified,Lost';
            OptionMembers = " ",Verified,Lost;
        }
        field(59006;"Dealer Code";Code[20])
        {
        }
    }

    keys
    {
        key(Key1;"Dealer Code","Entry No.")
        {
            Clustered = true;
        }
        key(Key2;"Item No.")
        {
            SumIndexFields = "Invoiced Quantity";
        }
        key(Key3;"Item No.","Posting Date")
        {
        }
        key(Key4;"Item No.","Entry Type","Variant Code","Drop Shipment","Location Code","Posting Date")
        {
            SumIndexFields = Quantity,"Invoiced Quantity";
        }
        key(Key5;"Source Type","Source No.","Item No.","Variant Code","Posting Date")
        {
            SumIndexFields = Quantity;
        }
        key(Key6;"Item No.",Open,"Variant Code",Positive,"Location Code","Posting Date")
        {
            SumIndexFields = Quantity,"Remaining Quantity";
        }
        key(Key7;"Item No.",Open,"Variant Code",Positive,"Location Code","Posting Date","Expiration Date","Lot No.","Serial No.")
        {
            SumIndexFields = Quantity,"Remaining Quantity";
        }
        key(Key8;"Country/Region Code","Entry Type","Posting Date")
        {
        }
        key(Key9;"Document No.","Document Type","Document Line No.")
        {
        }
        key(Key10;"Order Type","Order No.","Order Line No.","Entry Type","Prod. Order Comp. Line No.")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = Quantity;
        }
        key(Key11;"Item No.","Applied Entry to Adjust")
        {
        }
        key(Key12;"Item No.",Positive,"Location Code","Variant Code")
        {
        }
        key(Key13;"Item No.",Open,"Variant Code",Positive,"Lot No.","Serial No.")
        {
            MaintainSIFTIndex = false;
            MaintainSQLIndex = false;
        }
        key(Key14;"Item No.",Open,"Variant Code","Location Code","Item Tracking","Lot No.","Serial No.")
        {
            MaintainSIFTIndex = false;
            MaintainSQLIndex = false;
            SumIndexFields = "Remaining Quantity";
        }
        key(Key15;"Serial No.")
        {
        }
        key(Key16;"Supplier Code","Item No.","Parent Lot No.")
        {
        }
        key(Key17;"Serial No.","Location Code")
        {
            SumIndexFields = Quantity;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Entry No.",Description,"Item No.","Posting Date","Entry Type","Document No.")
        {
        }
    }

    trigger OnInsert()
    var
        GenJnlPostPreview: Codeunit "19";
    begin
    end;

    var
        GLSetup: Record "98";
        ReservEntry: Record "337";
        ReservEngineMgt: Codeunit "99000831";
        ReserveItemLedgEntry: Codeunit "99000841";
        ItemTrackingMgt: Codeunit "6500";
        GLSetupRead: Boolean;
        IsNotOnInventoryErr: Label 'You have insufficient quantity of Item %1 on inventory.';

    local procedure GetCurrencyCode(): Code[10]
    begin
        IF NOT GLSetupRead THEN BEGIN
          GLSetup.GET;
          GLSetupRead := TRUE;
        END;
        EXIT(GLSetup."Additional Reporting Currency");
    end;
}

