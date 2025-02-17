tableextension 50333 tableextension50333 extends "Transfer Line"
{
    // 21.05.2014 Elva Baltic P21 #F012 MMG7.00
    //   Added function:
    //     FindVehicleDimSetID
    //   Modified trigger:
    //     Item No. - OnValidate()
    // 
    // 29.04.2014 Elva Baltic P8 #F037 MMG7.00
    //   * Use of Def. Status from profile
    // 
    // 19.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added functions:
    //     GetReservationColor
    //     FilterTransferRes
    // 
    // 12.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Changed "Planning Flexibility" field InitValue property to None
    // 
    // 15.07.2013 EDMS P8
    //   * Fix for use veh. reservation
    // 
    // 27.04.2013 EDMS P8
    //   * Adjust to use veh. reservation
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 30)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Quantity Inbnd."(Field 50)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Quantity Outbnd."(Field 51)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Qty. Inbnd. (Base)"(Field 52)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Qty. Outbnd. (Base)"(Field 53)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Quantity Shipped"(Field 55)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Qty. Shipped (Base)"(Field 56)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Whse. Inbnd. Otsdg. Qty (Base)"(Field 5750)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Whse Outbnd. Otsdg. Qty (Base)"(Field 5751)".

        modify("Transfer-from Bin Code")
        {
            TableRelation = "Bin Content"."Bin Code" WHERE(Location Code=FIELD(Transfer-from Code),
                                                            Item No.=FIELD(Item No.),
                                                            Variant Code=FIELD(Variant Code));
        }


        //Unsupported feature: Code Insertion on ""Item No."(Field 3)".

        //trigger OnLookup(var Text: Text): Boolean
        //begin
            /*
            TransHeader.GET("Document No.");
            Item2.RESET;
            Item2.SETFILTER("Location Filter",'%1',TransHeader."Transfer-from Code");
            Item2.CALCFIELDS(Inventory);
            ItemList.LOOKUPMODE(TRUE);
            ItemList.SETRECORD(Item2);
            ItemList.SETTABLEVIEW(Item2);
            ItemList.SetLocationFilter;
            IF ItemList.RUNMODAL = ACTION::LookupOK THEN
              VALIDATE("Item No.",ItemList.GetItem);
            */
        //end;


        //Unsupported feature: Code Modification on ""Item No."(Field 3).OnValidate".

        //trigger "(Field 3)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TESTFIELD("Quantity Shipped",0);
            IF CurrFieldNo <> 0 THEN
              TestStatusOpen;
            #4..8
            TempTransferLine := Rec;
            INIT;
            "Item No." := TempTransferLine."Item No.";
            IF "Item No." = '' THEN
              EXIT;

            #15..26
            VALIDATE("Unit Volume",Item."Unit Volume");
            VALIDATE("Units per Parcel",Item."Units per Parcel");
            VALIDATE("Description 2",Item."Description 2");
            VALIDATE(Quantity,xRec.Quantity);
            "Item Category Code" := Item."Item Category Code";
            "Product Group Code" := Item."Product Group Code";

            CreateDim(DATABASE::Item,"Item No.");
            DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..11

            //EDMS1.0.00 >>
             VIN := TempTransferLine.VIN;
             "Make Code" := TempTransferLine."Make Code";
             "Model Code" := TempTransferLine."Model Code";
             "Model Version No." := TempTransferLine."Model Version No.";
             "Vehicle Serial No." := TempTransferLine."Vehicle Serial No.";
             "Vehicle Accounting Cycle No." := TempTransferLine."Vehicle Accounting Cycle No.";
             "Vehicle Assembly ID" := TempTransferLine."Vehicle Assembly ID";
             "Vehicle Status Code" := TempTransferLine."Vehicle Status Code";
            //29.04.2014 Elva Baltic P8 #F037 MMG7.00 >>
            IF "Vehicle Status Code" = '' THEN
              "Vehicle Status Code" := TransferRoute.GetVehicleStatusCode("Transfer-from Code", "Transfer-to Code");
            //29.04.2014 Elva Baltic P8 #F037 MMG7.00 <<
             "Document Profile" := TempTransferLine."Document Profile";
            //EDMS1.0.00 <<

             "Confirmed Date" := TempTransferLine."Confirmed Date";
             "Confirmed Time" := TempTransferLine."Confirmed Time";
             "Confirmed By" := TempTransferLine."Confirmed By";
             Confirmed := TempTransferLine.Confirmed;
            Tender := TempTransferLine.Tender;

            #12..29

            //EDMS1.0.00 >>
            IF "Document Profile" = "Document Profile"::"Vehicles Trade" THEN
              VALIDATE(Quantity,1)
            ELSE
            //EDMS1.0.00 <<

            #30..33
            //23.07.08 EDMS P1>>
            "Source Type" :=  TransHeader."Source Type";
            IF  TransHeader."Source Type" = DATABASE::"Service Header EDMS" THEN
             "Source Type" :=  DATABASE::"Service Line EDMS";
            "Source Subtype" :=  TransHeader."Source Subtype";
            "Source No." :=  TransHeader."Source No.";
            //23.07.08 EDMS P1<<


            //---surya 17 June 2012 -- get price from Sales Price Table
            //---Default Price Code field has been added to Location table to retrieve the division (CV or PC pricing group)
            PriceLocation.RESET;
            PriceLocation.SETRANGE(Code,"Transfer-from Code");
            IF PriceLocation.FINDFIRST THEN BEGIN
              IF PriceLocation."Default Price Group" = '' THEN BEGIN
                SalesPrice.SETRANGE("Item No.","Item No.");
                IF SalesPrice.FINDLAST THEN
                  VALIDATE("Unit Price",SalesPrice."Unit Price")
                ELSE
                  GetUnitPrice;
              END ELSE BEGIN
                SalesPrice.SETRANGE("Item No.","Item No.");
                SalesPrice.SETRANGE("Sales Code",PriceLocation."Default Price Group");
                IF SalesPrice.FINDLAST THEN
                  VALIDATE("Unit Price",SalesPrice."Unit Price")
                ELSE BEGIN
                  SalesPrice.RESET;
                  SalesPrice.SETRANGE("Item No.","Item No.");
                  IF SalesPrice.FINDLAST THEN
                    VALIDATE("Unit Price",SalesPrice."Unit Price")
                  ELSE
                    GetUnitPrice;
                END;
              END;
            END;
            ///-- end -- surya

            CreateDim(DATABASE::Item,"Item No.");
            DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");

            //26.02.2010 EDMS P2 >>
            GetNewDimensions;
            //26.02.2010 EDMS P2 <<


            "Requisition Date" := TODAY;
            Tender := TransHeader.Tender;

             {
             Itm.GET("Item No.");
             IF Rec.Quantity <> 0 THEN BEGIN
              ItmAttVal.RESET;
              ItmAttVal.SETRANGE("Table ID",DATABASE::Item);
              ItmAttVal.SETRANGE("No.","Item No.");
              IF ItmAttVal.FINDSET THEN REPEAT
               ItmVal.GET(ItmAttVal."Item Attribute ID");
               IF ItmVal."Value Type" <> ItmVal."Value Type"::" " THEN BEGIN
                 ItmAVal.GET(ItmAttVal."Item Attribute ID",ItmAttVal."Item Attribute Value ID");
                 EVALUATE(Dec,ItmAVal.Value);
                 CBM := CBM * Dec;
                END;
              UNTIL ItmAttVal.NEXT = 0;
              CBM := CBM * Quantity;
             END ELSE
              CBM := 0;
              }

             Item.GET("Item No.");
             IF Rec.Quantity <> 0 THEN
              CBM := Item.CBM * Rec.Quantity
              ELSE
              CBM := 0;
            */
        //end;


        //Unsupported feature: Code Insertion (VariableCollection) on "Quantity(Field 4).OnValidate".

        //trigger (Variable: Itm)()
        //Parameters and return type have not been exported.
        //begin
            /*
            */
        //end;


        //Unsupported feature: Code Modification on "Quantity(Field 4).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF CurrFieldNo <> 0 THEN
              TestStatusOpen;
            IF Quantity <> 0 THEN
            #4..21
            UpdateWithWarehouseShipReceive;

            WhseValidateSourceLine.TransLineVerifyChange(Rec,xRec);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..24

            //CBM
            {
             CBM := 1;
             Itm.GET("Item No.");
             IF Rec.Quantity <> 0 THEN BEGIN
              ItmAttVal.RESET;
              ItmAttVal.SETRANGE("Table ID",DATABASE::Item);
              ItmAttVal.SETRANGE("No.","Item No.");
              IF ItmAttVal.FINDSET THEN REPEAT
               ItmVal.GET(ItmAttVal."Item Attribute ID");
               IF ItmVal."Value Type" <> ItmVal."Value Type"::" " THEN BEGIN
                 ItmAVal.GET(ItmAttVal."Item Attribute ID",ItmAttVal."Item Attribute Value ID");
                 EVALUATE(Dec,ItmAVal.Value);
                 CBM := CBM * Dec;
                END;
              UNTIL ItmAttVal.NEXT = 0;
              CBM := CBM * Quantity;
             END ELSE
             CBM := 0;
             }
              Item.GET("Item No.");
             IF Rec.Quantity <> 0 THEN
              CBM := Item.CBM * Rec.Quantity
              ELSE
              CBM := 0;

            //CBM
            */
        //end;


        //Unsupported feature: Code Modification on ""Qty. to Ship"(Field 6).OnValidate".

        //trigger  to Ship"(Field 6)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            GetLocation("Transfer-from Code");
            IF CurrFieldNo <> 0 THEN BEGIN
              IF Location."Require Shipment" AND
            #4..14
              ELSE
                ERROR(Text006);
            "Qty. to Ship (Base)" := CalcBaseQty("Qty. to Ship");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..17

            IF Quantity <> 0 THEN
              UpdateAmount;
            */
        //end;


        //Unsupported feature: Code Modification on ""Qty. to Receive"(Field 7).OnValidate".

        //trigger  to Receive"(Field 7)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            GetLocation("Transfer-to Code");
            IF CurrFieldNo <> 0 THEN BEGIN
              IF Location."Require Receive" AND
            #4..6
              WhseValidateSourceLine.TransLineVerifyChange(Rec,xRec);
            END;

            IF "Qty. to Receive" > "Qty. in Transit" THEN
              IF "Qty. in Transit" > 0 THEN
                ERROR(
                  Text008,
                  "Qty. in Transit")
              ELSE
                ERROR(Text009);
            "Qty. to Receive (Base)" := CalcBaseQty("Qty. to Receive");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..9
            {IF "Qty. to Receive" > "Qty. in Transit" THEN
            #11..15
                ERROR(Text009);}
            "Qty. to Receive (Base)" := CalcBaseQty("Qty. to Receive");
            */
        //end;

        //Unsupported feature: Property Deletion (Editable) on ""Qty. per Unit of Measure"(Field 22)".



        //Unsupported feature: Code Modification on ""Unit of Measure Code"(Field 23).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF CurrFieldNo <> 0 THEN
              TestStatusOpen;
            TESTFIELD("Quantity Shipped",0);
            #4..18
            "Net Weight" := Item."Net Weight" * "Qty. per Unit of Measure";
            "Unit Volume" := Item."Unit Volume" * "Qty. per Unit of Measure";
            "Units per Parcel" := ROUND(Item."Units per Parcel" / "Qty. per Unit of Measure",0.00001);
            VALIDATE(Quantity);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..21

            IF "Unit Price" = 0 THEN
              GetUnitPrice;
            IF Quantity <> 0 THEN
              UpdateAmount;

            VALIDATE(Quantity);
            */
        //end;
        field(50000;Confirmed;Boolean)
        {
        }
        field(50001;"Confirmed Date";Date)
        {
        }
        field(50002;"Confirmed Time";Time)
        {
        }
        field(50003;"Confirmed By";Code[50])
        {
            TableRelation = "User Setup";
        }
        field(60000;"Allotment Date";Date)
        {
        }
        field(60001;"Allotment Time";Time)
        {
        }
        field(60002;"System Allotment";Boolean)
        {
        }
        field(60004;"Allotment Due Date";Date)
        {
        }
        field(60005;"Sys. LC No.";Code[20])
        {
            TableRelation = "LC Details".No.;

            trigger OnValidate()
            var
                LCAmendDetail: Record "33020013";
                LCDetail: Record "33020012";
                Text33020011: Label 'LC has amendments and amendment is not released.';
                Text33020012: Label 'LC has amendments and  amendment is closed.';
                Text33020013: Label 'LC Details is not released.';
                Text33020014: Label 'LC Details is closed.';
            begin
                //Code to check for LC Amendment and insert Bank LC No. and LC Amend No. (LC Version No.) if LC is amended atleast once.
                LCAmendDetail.RESET;
                LCAmendDetail.SETRANGE("No.","Sys. LC No.");
                IF LCAmendDetail.FIND('+') THEN BEGIN
                  IF NOT LCAmendDetail.Closed THEN BEGIN
                    IF LCAmendDetail.Released THEN BEGIN
                      "Bank LC No." := LCAmendDetail."Bank Amended No.";
                      MODIFY;
                    END ELSE
                      ERROR(Text33020011);
                  END ELSE
                    ERROR(Text33020012);
                END ELSE BEGIN
                  LCDetail.RESET;
                  LCDetail.SETRANGE("No.","Sys. LC No.");
                  IF LCDetail.FIND('-') THEN BEGIN
                    IF NOT LCDetail.Closed THEN BEGIN
                      IF LCDetail.Released THEN BEGIN
                        "Bank LC No." := LCDetail."LC\DO No.";
                        MODIFY;
                      END ELSE
                        ERROR(Text33020013);
                    END ELSE
                      ERROR(Text33020014);
                  END;
                END;

                IF ("Document Profile" = "Document Profile"::"Vehicles Trade") AND ("Sys. LC No." <> '') THEN BEGIN
                  "Confirmed Date" := TODAY;
                  "Confirmed Time" := TIME;
                  Confirmed := TRUE;
                  "Confirmed By" := USERID;
                END ELSE BEGIN
                  "Confirmed Date" := 0D;
                  "Confirmed Time" := 0T;
                  Confirmed := FALSE;
                  "Confirmed By" := '';
                END;
            end;
        }
        field(60006;"Bank LC No.";Code[20])
        {
        }
        field(60007;Tender;Boolean)
        {
        }
        field(70000;"Supplier Code";Code[10])
        {
            Description = 'QR19.00';
        }
        field(70001;"QR Enabled";Boolean)
        {
            CalcFormula = Exist(Item WHERE (No.=FIELD(Item No.),
                                            Item Tracking Code=FILTER(<>' ')));
            FieldClass = FlowField;
        }
        field(70002;"Old Lot";Code[20])
        {
            CalcFormula = Lookup("Item Ledger Entry"."Lot No." WHERE (Lot No.=CONST(76/77-OLDLOT),
                                                                      Remaining Quantity=FILTER(>0),
                                                                      Item No.=FIELD(Item No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006000;"Document Profile";Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006010;"From Location Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1,' + Text107;
            Caption = 'From Location Dimension Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
        }
        field(25006020;"From Location Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2,' + Text107;
            Caption = 'From Location Dimension Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
        }
        field(25006030;"To Location Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1,' + Text108;
            Caption = 'To Location Dimension Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
        }
        field(25006040;"To Location Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2,' + Text108;
            Caption = 'To Location Dimension Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
        }
        field(25006160;"Source Type";Integer)
        {
            Caption = 'Source Type';
            Editable = false;
        }
        field(25006166;"Source Subtype";Option)
        {
            Caption = 'Source Subtype';
            Editable = false;
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
        }
        field(25006170;"Vehicle Registration No.";Code[20])
        {
            Caption = 'Vehicle Registration No.';
            Editable = false;

            trigger OnLookup()
            begin
                OnLookupVehicleRegistrationNo;
            end;

            trigger OnValidate()
            var
                Vehicle: Record "25006005";
            begin
                IF "Vehicle Registration No." = '' THEN BEGIN
                  VALIDATE("Vehicle Serial No.",'');
                  EXIT;
                END;

                Vehicle.RESET;
                Vehicle.SETCURRENTKEY("Registration No.");
                Vehicle.SETRANGE("Registration No.","Vehicle Registration No.");
                IF Vehicle.FINDFIRST THEN BEGIN
                  IF "Vehicle Serial No." <> Vehicle."Serial No." THEN
                    VALIDATE("Vehicle Serial No.",Vehicle."Serial No.")
                END ELSE
                  MESSAGE(STRSUBSTNO(Text105, "Vehicle Registration No."), '');
            end;
        }
        field(25006200;"Source No.";Code[20])
        {
            Caption = 'Source No.';
            Editable = false;
            TableRelation = IF (Source Type=CONST(25006145)) "Service Header EDMS".No. WHERE (Document Type=FIELD(Source Subtype));
        }
        field(25006370;"Make Code";Code[20])
        {
            Caption = 'Make Code';
            Editable = true;
            TableRelation = Make;
        }
        field(25006371;"Model Code";Code[20])
        {
            Caption = 'Model Code';
            Editable = true;
            TableRelation = Model.Code WHERE (Make Code=FIELD(Make Code));
        }
        field(25006373;VIN;Code[20])
        {
            CalcFormula = Lookup(Vehicle.VIN WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            var
                Vehicle: Record "25006005";
            begin
                Vehicle.RESET;
                IF LookUpMgt.LookUpVehicleAMT(Vehicle,"Vehicle Serial No.") THEN
                 VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
            end;

            trigger OnValidate()
            var
                recSalesLine: Record "37";
                tcAMT001: Label 'This VIN is being used in %1. Are you shore that you want to use exactly this VIN?';
                recVehicle: Record "25006005";
                tcAMT002: Label 'Serial No. in Vehicle table differs from Serial No. in Sales Line.';
            begin
                TestStatusOpen;
            end;
        }
        field(25006374;"Model Version No.";Code[20])
        {
            Caption = 'Model Version No.';
            Editable = true;
            TableRelation = Item.No. WHERE (Make Code=FIELD(Make Code),
                                            Model Code=FIELD(Model Code),
                                            Item Type=CONST(Model Version));

            trigger OnLookup()
            var
                Item: Record "27";
            begin
                Item.RESET;
                IF LookUpMgt.LookUpModelVersion(Item,"Item No.","Make Code","Model Code") THEN BEGIN
                  //ALT1.00
                  "Make Code" := Item."Make Code";
                  "Model Code" := Item."Model Code";
                  //ALT1.00
                  VALIDATE("Model Version No.",Item."No.");
                END;
            end;

            trigger OnValidate()
            var
                recVehicle: Record "25006005";
            begin
                TestStatusOpen;

                IF "Document Profile" = "Document Profile"::"Vehicles Trade" THEN
                 VALIDATE("Item No.","Model Version No.");


                //ALT1.00
                IF "Vehicle Serial No." = '' THEN
                  NewSerialNo;
                //ALT1.00
            end;
        }
        field(25006375;"Vehicle Serial No.";Code[20])
        {
            Caption = 'Vehicle Serial No.';

            trigger OnValidate()
            var
                Vehicle: Record "25006005";
                SerialNoPre: Code[20];
                lCCMemoLine: Record "33020164";
                DefCycle: Code[20];
                Vehi: Record "33019823";
            begin
                TestStatusOpen;
                
                IF "Vehicle Serial No." = '' THEN
                 BEGIN
                  VIN := '';
                  "Vehicle Accounting Cycle No." := '';
                  "Vehicle Registration No." := '';
                 END
                ELSE
                 BEGIN
                  IF Vehicle.GET("Vehicle Serial No.") THEN
                   BEGIN
                     IF Vehi.GET("Vehicle Serial No.") THEN; //v2
                    SerialNoPre := "Vehicle Serial No.";
                    VALIDATE("Make Code",Vehicle."Make Code");
                    VALIDATE("Model Code",Vehicle."Model Code");
                    VALIDATE("Model Version No.",Vehicle."Model Version No.");
                    VIN := Vehicle.VIN;
                    "Vehicle Serial No." := SerialNoPre;
                
                    Vehi.CALCFIELDS("Default Vehicle Acc. Cycle No.");
                    VALIDATE("Vehicle Accounting Cycle No.",Vehi."Default Vehicle Acc. Cycle No.");
                    "Vehicle Registration No." := Vehicle."Registration No.";
                    //29.04.2014 Elva Baltic P8 #F037 MMG7.00 >>
                    IF "Vehicle Status Code" = '' THEN
                      "Vehicle Status Code" := TransferRoute.GetVehicleStatusCode("Transfer-from Code", "Transfer-to Code");
                    IF "Vehicle Status Code" = '' THEN
                      "Vehicle Status Code" := Vehicle."Status Code";
                    //29.04.2014 Elva Baltic P8 #F037 MMG7.00 <<
                    VALIDATE("Vehicle Status Code");
                
                    // Copying CC Memo number from >>
                    lCCMemoLine.SETRANGE("Vehicle Serial No.","Vehicle Serial No.");
                    IF lCCMemoLine.FINDFIRST THEN
                       "CC Memo No.":=lCCMemoLine."Reference No.";
                
                    //** SM 06-04-2013 @Agni as PP no. will not be available at Location Raxaul.
                    Location.RESET;
                    Location.SETRANGE(Code,"Transfer-from Code");
                    IF Location.FINDFIRST THEN BEGIN
                      IF Location."PP Mandatory Check" THEN
                          Vehicle.TESTFIELD("PP No.");
                    END;
                    //** SM 06-04-2013 @Agni as PP no. will not be available at Location Raxaul.
                
                     "PP No.":=Vehicle."PP No.";
                    // Copying CC Memo number from <<
                
                
                   //** SM 06-18-2013 @Agni as insurance is covered to Location Birgunj
                  TransHdr1.RESET;
                  TransHdr1.SETRANGE("No.","Document No.");
                  IF TransHdr1.FINDFIRST THEN BEGIN
                    Location.RESET;
                    Location.SETRANGE(Code,TransHdr1."Transfer-to Code");
                    IF Location.FINDFIRST THEN BEGIN
                      IF Location."Insurance No. Check" THEN BEGIN
                          Location1.RESET;
                          Location1.SETRANGE(Code,TransHdr1."Transfer-from Code");
                          IF Location1.FINDFIRST THEN BEGIN
                             IF Location1."Insurance No. Check" THEN BEGIN
                                Vehi.CALCFIELDS("Insurance Memo No."); //v2
                                Vehi.TESTFIELD("Insurance Memo No.");
                                //Vehicle.CALCFIELDS("Insurance Policy No.");
                                //Vehicle.TESTFIELD("Insurance Policy No.");
                             END;
                          END;
                      END;
                    END;
                  END;
                    //** SM 06-18-2013 @Agni as insurance is covered to Location Birgunj
                    END;
                
                  LicensePermission.SETRANGE("Object Type",LicensePermission."Object Type"::Codeunit);
                  LicensePermission.SETRANGE("Object Number",CODEUNIT::VehicleAccountingCycleMgt);
                  LicensePermission.SETFILTER("Execute Permission",'<>%1',LicensePermission."Execute Permission"::" ");
                  IF LicensePermission.FIND('-') THEN BEGIN
                    DefCycle := VehAccCycleMgt.GetDefaultCycle("Vehicle Serial No.","Vehicle Accounting Cycle No.");
                    IF DefCycle = '' THEN
                     NewAccCycleNo
                    ELSE
                     VALIDATE("Vehicle Accounting Cycle No.",DefCycle);
                  END;
                 END;
                
                /*
                //*** SM 26-06-2013 to check the valid period of the created insurance memo for the specific vehicles
                InsMemoLine.RESET;
                InsMemoLine.SETRANGE("Vehicle Serial No.","Vehicle Serial No.");
                IF InsMemoLine.FINDLAST THEN BEGIN
                   REPEAT
                      RefNo := InsMemoLine."Reference No.";
                      InsMemoHdr.RESET;
                      InsMemoHdr.SETRANGE("Reference No.",RefNo);
                      IF InsMemoHdr.FINDLAST THEN BEGIN
                         CheckDate := CALCDATE('+' +FORMAT(InsMemoHdr."Valid Period"),InsMemoHdr."Memo Date");
                         MESSAGE(FORMAT(CheckDate));
                         IF WORKDATE > CheckDate THEN
                            ERROR(ExpiredInsMemo,VIN);
                      END;
                   UNTIL InsMemoLine.NEXT = 0;
                END;
                //*** SM 26-06-2013 to check the valid period of the created insurance memo for the specific vehicles
                */
                
                //***SM 04-07-2013 to flow the same variant code in transfer line for the vehicle
                ItemLedgerEntry.RESET;
                ItemLedgerEntry.SETFILTER("Entry Type",'Purchase');
                ItemLedgerEntry.CALCFIELDS(VIN);
                CALCFIELDS(VIN);
                ItemLedgerEntry.SETRANGE(VIN,VIN);
                IF ItemLedgerEntry.FINDFIRST THEN BEGIN
                   "Variant Code" := ItemLedgerEntry."Variant Code";
                END;
                //***SM 04-07-2013 to flow the same variant code in transfer line for the vehicle
                
                IF "Vehicle Serial No." <> xRec."Vehicle Serial No." THEN
                  "Vehicle Assembly ID" := '';

            end;
        }
        field(25006376;"Vehicle Assembly ID";Code[20])
        {
            Caption = 'Vehicle Assembly ID';

            trigger OnValidate()
            var
                VehAssembly: Record "25006380";
            begin
                TESTFIELD("Vehicle Serial No.");
                IF (xRec."Vehicle Assembly ID" <> '') AND (xRec."Vehicle Assembly ID" <> Rec."Vehicle Assembly ID") THEN
                 BEGIN
                  VehAssembly.RESET;
                  VehAssembly.SETRANGE("Serial No.",xRec."Vehicle Serial No.");
                  VehAssembly.SETRANGE("Assembly ID",xRec."Vehicle Assembly ID");
                  IF NOT VehAssembly.ISEMPTY THEN
                   ERROR(Text100,xRec."Vehicle Assembly ID");
                 END;
            end;
        }
        field(25006379;"Vehicle Accounting Cycle No.";Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';

            trigger OnLookup()
            var
                VehAccCycle: Record "25006024";
            begin
                VehAccCycle.RESET;
                IF LookUpMgt.LookUpVehicleAccCycle(VehAccCycle,"Vehicle Serial No.","Vehicle Accounting Cycle No.") THEN
                 VALIDATE("Vehicle Accounting Cycle No.",VehAccCycle."No.");
            end;

            trigger OnValidate()
            var
                cuVehAccCycle: Codeunit "25006303";
            begin
                TestStatusOpen;
                cuVehAccCycle.CheckCycleRelation("Vehicle Serial No.","Vehicle Accounting Cycle No.");
            end;
        }
        field(25006380;"Vehicle Status Code";Code[20])
        {
            Caption = 'Vehicle Status Code';
            TableRelation = "Vehicle Status".Code;
        }
        field(25006382;"Reserved Inbound";Boolean)
        {
            CalcFormula = Exist("Vehicle Reservation Entry" WHERE (Source Type=CONST(5741),
                                                                   Source ID=FIELD(Document No.),
                                                                   Source Ref. No.=FIELD(Line No.),
                                                                   Source Subtype=CONST(1)));
            Caption = 'Reserved Inbound';
            Description = 'Only for Vehicles';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006383;"Reserved Outbound";Boolean)
        {
            CalcFormula = Exist("Vehicle Reservation Entry" WHERE (Source Type=CONST(5741),
                                                                   Source ID=FIELD(Document No.),
                                                                   Source Ref. No.=FIELD(Line No.),
                                                                   Source Subtype=CONST(0)));
            Caption = 'Reserved Outbound';
            Description = 'Only for Vehicles';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006390;Kilometrage;Integer)
        {
        }
        field(25006996;"Variable Field Run 2";Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,5741,25006996';
        }
        field(25006997;"Variable Field Run 3";Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,5741,25006997';
        }
        field(33019831;"Reason Code";Code[20])
        {
            TableRelation = "Transfer Reason Code".No.;
        }
        field(33019832;Inventory;Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE (Item No.=FIELD(Item No.),
                                                                  Location Code=FIELD(Transfer-from Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33019834;"Unit Price";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
            Editable = true;
        }
        field(33019835;Amount;Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
            Editable = false;
        }
        field(33019836;"Requisition Date";Date)
        {
            Editable = false;
        }
        field(33020163;"CC Memo No.";Code[20])
        {
            TableRelation = "CC Memo Header"."Reference No." WHERE (Posted=CONST(Yes));
        }
        field(33020164;"PP No.";Code[20])
        {
        }
        field(33020165;"Assigned User ID";Code[50])
        {
            CalcFormula = Lookup("Transfer Header"."Assigned User ID" WHERE (No.=FIELD(Document No.)));
            FieldClass = FlowField;
        }
        field(99000756;"Document Date";Date)
        {
        }
        field(99000757;CBM;Decimal)
        {
            DecimalPlaces = 0:6;
        }
    }
    keys
    {
        key(Key1;"Model Version No.","Transfer-to Code","Allotment Date",Tender,"System Allotment")
        {
            SumIndexFields = "Qty. to Receive";
        }
    }


    //Unsupported feature: Code Modification on "OnDelete".

    //trigger OnDelete()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        TestStatusOpen;

        TESTFIELD("Quantity Shipped","Quantity Received");
        TESTFIELD("Qty. Shipped (Base)","Qty. Received (Base)");
        CALCFIELDS("Reserved Qty. Inbnd. (Base)","Reserved Qty. Outbnd. (Base)");
        TESTFIELD("Reserved Qty. Inbnd. (Base)",0);
        TESTFIELD("Reserved Qty. Outbnd. (Base)",0);

        ReserveTransferLine.DeleteLine(Rec);
        WhseValidateSourceLine.TransLineDelete(Rec);
        #11..14
        ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.","Document No.");
        ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.","Line No.");
        ItemChargeAssgntPurch.DELETEALL(TRUE);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..7
        //15.07.2013 EDMS P8 >>
        IF "Document Profile" = "Document Profile"::"Vehicles Trade" THEN BEGIN
          IF GetReservedQtyVeh('', TRUE, 0, FALSE)<>0 THEN
            ERROR(Text109, TABLECAPTION, "Document No."+' '+FORMAT("Line No.") + ';');
        END;
        //15.07.2013 EDMS P8 <<

        #8..17
        */
    //end;


    //Unsupported feature: Code Modification on "OnInsert".

    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        TestStatusOpen;
        TransLine2.RESET;
        TransLine2.SETFILTER("Document No.",TransHeader."No.");
        IF TransLine2.FINDLAST THEN
          "Line No." := TransLine2."Line No." + 10000;
        ReserveTransferLine.VerifyQuantity(Rec,xRec);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..6
        "Requisition Date" := TODAY;
        */
    //end;


    //Unsupported feature: Code Modification on "OnModify".

    //trigger OnModify()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        ReserveTransferLine.VerifyChange(Rec,xRec);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        IF "Document Profile" = "Document Profile"::"Vehicles Trade" THEN
          ReserveTransferVehLine.VerifyChange(Rec,xRec)
        ELSE
          ReserveTransferLine.VerifyChange(Rec,xRec);
        */
    //end;

    //Unsupported feature: Variable Insertion (Variable: TransferLine2) (VariableCollection) on "GetTransHeader(PROCEDURE 1)".


    //Unsupported feature: Variable Insertion (Variable: AlreadySelectedItem) (VariableCollection) on "GetTransHeader(PROCEDURE 1)".



    //Unsupported feature: Code Modification on "GetTransHeader(PROCEDURE 1)".

    //procedure GetTransHeader();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        TESTFIELD("Document No.");
        IF "Document No." <> TransHeader."No." THEN
          TransHeader.GET("Document No.");
        #4..17
        "Outbound Whse. Handling Time" := TransHeader."Outbound Whse. Handling Time";
        "Inbound Whse. Handling Time" := TransHeader."Inbound Whse. Handling Time";
        Status := TransHeader.Status;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..20
        "Document Date" := TransHeader."Document Date"; //MIN 5/6/2019

        {
        //Sipradi-YS * Do not give user to choose same item multiple times.
        TransferLine2.RESET;
        TransferLine2.SETRANGE("Document No.","Document No.");
        TransferLine2.SETRANGE("Item No.","Item No.");
        TransferLine2.SETRANGE("Derived From Line No.",0);
        IF TransferLine2.FINDFIRST THEN
          ERROR(AlreadySelectedItem,"Item No.");
        //Sipradi-YS
        }//sm
        */
    //end;


    //Unsupported feature: Code Modification on "VerifyItemLineDim(PROCEDURE 87)".

    //procedure VerifyItemLineDim();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF IsShippedDimChanged THEN
          ConfirmShippedDimChange;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        //IF IsShippedDimChanged THEN
          //ConfirmShippedDimChange;
        */
    //end;

    procedure AutoReserveServ(Direction: Option Outbound,Inbound) FullReservation: Boolean
    var
        ReservMgt: Codeunit "99000845";
    begin
        //EDMS function
        TESTFIELD("Item No.");
        ReservMgt.SetTransferLine(Rec,Direction);
        TESTFIELD("Shipment Date");
        CALCFIELDS("Reserved Quantity Inbnd.","Reserved Quantity Outbnd.");

        IF Direction = Direction::Outbound THEN BEGIN
          ReservMgt.SetSpecSummEntryNo(220);

        // 26.10.2012 EDMS >>
          ReservMgt.AutoReserve(FullReservation,'',"Shipment Date","Outstanding Qty. (Base)"-"Reserved Quantity Outbnd.",
          "Outstanding Qty. (Base)"-"Reserved Quantity Outbnd.");
        // 26.10.2012 EDMS <<

         END
        ELSE BEGIN
          ReservMgt.SetSpecSummEntryNo(220);

        // 26.10.2012 EDMS >>
          ReservMgt.AutoReserve(FullReservation,'',"Receipt Date","Outstanding Qty. (Base)"-"Reserved Quantity Inbnd.",
          "Outstanding Qty. (Base)"-"Reserved Quantity Inbnd.");
        // 26.10.2012 EDMS <<

         END;

        FIND;
    end;

    procedure NewVehAssemblyNo()
    var
        InvSetup: Record "313";
        NoSeriesMgt: Codeunit "396";
        AssemblyNo: Code[20];
    begin
        IF "Document Profile" = "Document Profile"::"Vehicles Trade" THEN BEGIN
           InvSetup.GET;
           InvSetup.TESTFIELD("Vehicle Assembly Nos.");
           NoSeriesMgt.InitSeries(InvSetup."Vehicle Assembly Nos.",InvSetup."Vehicle Assembly Nos.",
              WORKDATE,AssemblyNo,InvSetup."Vehicle Assembly Nos.");
           VALIDATE("Vehicle Assembly ID",AssemblyNo);
           MODIFY;
        END;
    end;

    procedure VehicleAssembly()
    var
        VehicleAssemby: Record "25006380";
        VehAssemblyWorksheet: Page "25006490";
                                  InvSetup: Record "313";
                                  NoSeriesMgt: Codeunit "396";
                                  VehOptMgt: Codeunit "25006304";
                                  SalesHeader: Record "36";
                                  CurrencyDate: Date;
                                  VehPriceMgt: Codeunit "25006301";
    begin
        IF "Document Profile" <> "Document Profile"::"Vehicles Trade" THEN
         EXIT;

        TESTFIELD("Item No.");
        TESTFIELD("Vehicle Serial No.");
        TESTFIELD("Make Code");
        TESTFIELD("Model Code");
        TESTFIELD("Model Version No.");

        IF "Vehicle Assembly ID" = '' THEN
          NewVehAssemblyNo;

        VehPriceMgt.ChkAssemblyHdrTransferLine(Rec);
        VehOptMgt.FillVehAssembly("Vehicle Serial No.","Vehicle Assembly ID",
          "Make Code","Model Code","Model Version No.");

        COMMIT;

         VehicleAssemby.SETRANGE("Assembly ID","Vehicle Assembly ID");
         VehicleAssemby.SETRANGE("Make Code","Make Code");
         VehicleAssemby.SETRANGE("Model Code","Model Code");
         VehicleAssemby.SETRANGE("Model Version No.","Model Version No.");
         VehicleAssemby.SETRANGE("Serial No.","Vehicle Serial No.");

         CLEAR(VehAssemblyWorksheet);
         VehAssemblyWorksheet.SETTABLEVIEW(VehicleAssemby);
         VehAssemblyWorksheet.RUNMODAL;
    end;

    procedure GetNewDimensions()
    var
        GLSetup: Record "98";
        LocationDimensionSetup: Record "25006049";
    begin
        GLSetup.GET;

        IF LocationDimensionSetup.GET("Transfer-from Code", "Item Category Code", GLSetup."Global Dimension 1 Code") THEN
          "From Location Dimension 1 Code" := LocationDimensionSetup."Dimension Value Code";
        IF LocationDimensionSetup.GET("Transfer-from Code", "Item Category Code", GLSetup."Global Dimension 2 Code") THEN
          "From Location Dimension 2 Code" := LocationDimensionSetup."Dimension Value Code";

        IF LocationDimensionSetup.GET("Transfer-to Code", "Item Category Code", GLSetup."Global Dimension 1 Code") THEN
          "To Location Dimension 1 Code" := LocationDimensionSetup."Dimension Value Code";
        IF LocationDimensionSetup.GET("Transfer-to Code", "Item Category Code", GLSetup."Global Dimension 2 Code") THEN
          "To Location Dimension 2 Code" := LocationDimensionSetup."Dimension Value Code";
    end;

    procedure ShowReservationEntries(Modal: Boolean;Direction: Option Outbound,Inbound)
    var
        ReservEntry: Record "337";
        ReservEngineMgt: Codeunit "99000831";
        ReserveTransferLine: Codeunit "99000836";
    begin
        TESTFIELD("Item No.");
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,TRUE);
        ReserveTransferLine.FilterReservFor(ReservEntry,Rec,Direction);
        IF Modal THEN
          PAGE.RUNMODAL(PAGE::"Reservation Entries",ReservEntry)
        ELSE
          PAGE.RUN(PAGE::"Reservation Entries",ReservEntry);
    end;

    procedure AutoReserveSilent(Direction: Option Outbound,Inbound)
    var
        ReservMgt: Codeunit "99000845";
        FullAutoReservation: Boolean;
        ReservQuantity: Decimal;
        ResDate: Date;
        ServTransfMgt: Codeunit "25006010";
    begin
        //EDMS function
        TESTFIELD("Item No.");
        ReservMgt.SetTransferLine(Rec,Direction);

        CASE Direction OF
          Direction::Outbound: BEGIN
            ReservQuantity := Quantity - "Quantity Shipped";
            ResDate := "Shipment Date";
            IF ServTransfMgt.IsServiceLocation("Transfer-from Code") THEN
              ReservMgt.SetSpecSummEntryNo(1);
          END;
          Direction::Inbound: BEGIN
            ReservQuantity := Quantity - "Quantity Received";
            ResDate := "Receipt Date";
            IF ServTransfMgt.IsServiceLocation("Transfer-to Code") THEN
              ReservMgt.SetSpecSummEntryNo(220);
          END;
        END;

        IF ReservQuantity <> 0 THEN BEGIN
          TESTFIELD("Shipment Date");
        // 26.10.2012 EDMS >>
          ReservMgt.AutoReserve(FullAutoReservation,'',ResDate,ReservQuantity,ReservQuantity);
        // 26.10.2012 EDMS <<
          FIND;
        END;
    end;

    procedure ShowVehReservation()
    var
        VehReservation: Page "25006529";
                            OptionNumber: Integer;
    begin
        TESTFIELD("Document Profile", "Document Profile"::"Vehicles Trade");
        TESTFIELD("Item No.");
        //TESTFIELD(Reserve);
        CLEAR(VehReservation);
        OptionNumber := STRMENU(Text011);
        IF OptionNumber > 0 THEN BEGIN
          VehReservation.SetTransLine(Rec,OptionNumber - 1);
          VehReservation.RUNMODAL;
        END;
    end;

    procedure ShowVehReservationEntries(Modal: Boolean;Direction: Option Outbound,Inbound)
    var
        VehReservEngineMgt: Codeunit "25006316";
        VehReserveSalesLine: Codeunit "25006317";
        VehReservEntry: Record "25006392";
    begin
        TESTFIELD("Document Profile", "Document Profile"::"Vehicles Trade");
        TESTFIELD("Item No.");
        /*
        VehReservEngineMgt.InitFilterAndSortingLookupFor(VehReservEntry);
        VehReserveSalesLine.FilterReservFor(VehReservEntry,Rec);
        IF Modal THEN
          PAGE.RUNMODAL(PAGE::"Vehicle Reservation Entries",VehReservEntry)
        ELSE
          PAGE.RUN(PAGE::"Vehicle Reservation Entries",VehReservEntry);
         */

    end;

    procedure GetReservedQtyVeh(SourceBatchName: Code[10];DoFilterByBatch: Boolean;SourceSubtype: Integer;DoFilterBySubtype: Boolean) RetValue: Decimal
    var
        VehicleReservationEntry: Record "25006392";
    begin
        //15.07.2013 EDMS P8 >>
        VehicleReservationEntry.RESET;
        VehicleReservationEntry.SETRANGE("Vehicle Serial No.", "Vehicle Serial No.");
        VehicleReservationEntry.SETRANGE("Source Type", DATABASE::"Transfer Line");
        IF DoFilterBySubtype THEN
          VehicleReservationEntry.SETRANGE("Source Subtype", SourceSubtype);
        VehicleReservationEntry.SETRANGE("Source ID", "Document No.");
        IF DoFilterByBatch THEN
          VehicleReservationEntry.SETRANGE("Source Batch Name", SourceBatchName);
        VehicleReservationEntry.SETRANGE("Source Ref. No.", "Line No.");
        RetValue := 0;
        IF VehicleReservationEntry.FINDFIRST THEN BEGIN
          RetValue := VehicleReservationEntry.Quantity;
          IF NOT VehicleReservationEntry.Positive THEN
            RetValue := RetValue * (-1);
        END;
        EXIT(RetValue);
    end;

    procedure GetReservationColor(): Text[20]
    var
        ResEntry: Record "337";
    begin
        FilterTransferRes(ResEntry);

        IF ResEntry.ISEMPTY THEN
          EXIT('None');

        ResEntry.SETRANGE("Source Type", 246);
        IF ResEntry.FINDFIRST THEN
          EXIT('StandardAccent');

        ResEntry.SETFILTER("Source Type", '%1|%2', 39, 5741);
        IF ResEntry.FINDFIRST THEN
          EXIT('Ambiguous');

        ResEntry.SETRANGE("Source Type", 32);
        IF ResEntry.FINDFIRST THEN
          EXIT('Favorable');
    end;

    procedure FilterTransferRes(var FilteredResEntry: Record "337")
    var
        ResEntryNegative: Record "337";
        ResEntryTransferOutg: Record "337";
    begin
        //receivment into transfer
        ResEntryNegative.RESET;
        ResEntryNegative.SETCURRENTKEY("Source ID","Source Ref. No.","Source Type","Source Subtype");
        ResEntryNegative.SETRANGE("Source ID","Document No.");
        ResEntryNegative.SETRANGE("Source Ref. No.","Line No.");
        ResEntryNegative.SETRANGE("Source Type",DATABASE::"Transfer Line");
        ResEntryNegative.SETRANGE("Source Subtype",0);
        ResEntryNegative.SETRANGE("Source Prod. Order Line","Derived From Line No.");
        ResEntryNegative.SETRANGE("Reservation Status",ResEntryNegative."Reservation Status"::Reservation);
        IF ResEntryNegative.FINDFIRST THEN
          REPEAT
            FilteredResEntry.GET(ResEntryNegative."Entry No.",TRUE);
            FilteredResEntry.MARK(TRUE);
          UNTIL ResEntryNegative.NEXT = 0;
        FilteredResEntry.MARKEDONLY(TRUE)
    end;

    procedure OnLookupVehicleRegistrationNo()
    var
        Vehicle: Record "25006005";
    begin
        IF "Vehicle Registration No." <> '' THEN BEGIN
          Vehicle.RESET;
          Vehicle.SETCURRENTKEY("Registration No.");
          Vehicle.SETRANGE("Registration No.","Vehicle Registration No.");
          IF Vehicle.FINDFIRST THEN;
          Vehicle.SETRANGE("Registration No.");
        END;

        IF LookUpMgt.LookUpVehicleAMT(Vehicle,"Vehicle Serial No.") THEN
         VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
    end;

    local procedure GetUnitPrice()
    begin
        TESTFIELD("Item No.");
        IF Item2.GET("Item No.") THEN BEGIN
          "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");
          VALIDATE("Unit Price",Item2."Unit Price" * "Qty. per Unit of Measure");
        END;
    end;

    procedure UpdateAmount()
    begin
        TESTFIELD(Quantity);
        //TESTFIELD("Unit of Measure"); *** SM commented 06 Jan 2014
        VALIDATE(Amount,"Qty. to Ship"*"Unit Price");
    end;

    procedure GetPrice()
    begin
    end;

    procedure "--ALT1.00--"()
    begin
    end;

    procedure NewSerialNo()
    var
        InvSetup: Record "313";
        NoSeriesMgt: Codeunit "396";
        SerialNo: Code[20];
    begin
        InvSetup.GET;
        InvSetup.TESTFIELD("Vehicle Serial No. Nos.");
        NoSeriesMgt.InitSeries(InvSetup."Vehicle Serial No. Nos.",InvSetup."Vehicle Serial No. Nos.",
           WORKDATE,SerialNo,InvSetup."Vehicle Serial No. Nos.");
        VALIDATE("Vehicle Serial No.",SerialNo);
    end;

    procedure NewAccCycleNo()
    var
        recInvSetup: Record "313";
        cuNoSeriesMgt: Codeunit "396";
        codCycleNo: Code[20];
        recVehAccCycle: Record "25006024";
        cuVehAccCycle: Codeunit "25006303";
    begin
        IF "Vehicle Accounting Cycle No." <> '' THEN
          EXIT;

        TESTFIELD("Vehicle Serial No.");

        codCycleNo := cuVehAccCycle.GetNewCycleNo;

        recVehAccCycle.INIT;
         recVehAccCycle."No." := codCycleNo;
         recVehAccCycle.VALIDATE("Vehicle Serial No.","Vehicle Serial No.");
         recVehAccCycle.VALIDATE(Default,TRUE);
        recVehAccCycle.INSERT(TRUE);

        VALIDATE("Vehicle Accounting Cycle No.",codCycleNo);
    end;

    var
        Itm: Record "27";
        ItmAttVal: Record "7505";
        ItmVal: Record "7500";
        ItmAVal: Record "7501";
        Dec: Decimal;

    var
        Itm: Record "27";
        ItmAttVal: Record "7505";
        ItmVal: Record "7500";
        ItmAVal: Record "7501";
        Dec: Decimal;


    //Unsupported feature: Property Modification (Id) on "LedgEntryWillBeOpenedMsg(Variable 1021)".

    //var
        //>>>> ORIGINAL VALUE:
        //LedgEntryWillBeOpenedMsg : 1021;
        //Variable type has not been exported.
        //>>>> MODIFIED VALUE:
        //LedgEntryWillBeOpenedMsg : 1050;
        //Variable type has not been exported.

    var
        ReserveTransferVehLine: Codeunit "25006321";

    var
        LookUpMgt: Codeunit "25006003";
        Text100: Label 'Vehicle assembly list %1 is not empty.';
        Text107: Label 'From Location ';
        Text108: Label 'To Location ';
        Text109: Label '%1 with %2 has reservation, delete/cancel it first.';
        Text105: Label 'There is no vehicle with Registration No. %1';
        ItemList: Page "31";
                      Item2: Record "27";
                      UOMMgt: Codeunit "5402";
                      SalesPrice: Record "7002";
                      PriceLocation: Record "14";
                      InsMemoHdr: Record "33020165";
                      InsMemoLine: Record "33020166";
                      RefNo: Code[20];
                      CheckDate: Date;
                      Expr: Text[50];
                      ItemLedgerEntry: Record "32";
                      Location1: Record "14";
                      TransHdr1: Record "5740";
                      LicensePermission: Record "2000000043";
                      VehAccCycleMgt: Codeunit "25006303";
                      ExpiredInsMemo: Label 'The insurance date is expired. Please create a new Insurance Memo for the vehicle %1.';
}

