tableextension 50350 tableextension50350 extends "Item Charge Assignment (Sales)"
{
    // 09.01.2014 EDMS P15
    //   * Type of "Vehicle Accounting Cycle No." changed from FlowField to Normal ones
    fields
    {
        modify("Document Line No.")
        {
            TableRelation = "Sales Line"."Line No." WHERE(Document Type=FIELD(Document Type),
                                                           Document No.=FIELD(Document No.));
        }
        modify("Applies-to Doc. No.")
        {
            TableRelation = IF (Applies-to Doc. Type=CONST(Order)) "Sales Header".No. WHERE (Document Type=CONST(Order))
                            ELSE IF (Applies-to Doc. Type=CONST(Invoice)) "Sales Header".No. WHERE (Document Type=CONST(Invoice))
                            ELSE IF (Applies-to Doc. Type=CONST(Return Order)) "Sales Header".No. WHERE (Document Type=CONST(Return Order))
                            ELSE IF (Applies-to Doc. Type=CONST(Credit Memo)) "Sales Header".No. WHERE (Document Type=CONST(Credit Memo))
                            ELSE IF (Applies-to Doc. Type=CONST(Shipment)) "Sales Shipment Header".No.
                            ELSE IF (Applies-to Doc. Type=CONST(Return Receipt)) "Return Receipt Header".No.;
        }
        modify("Applies-to Doc. Line No.")
        {
            TableRelation = IF (Applies-to Doc. Type=CONST(Order)) "Sales Line"."Line No." WHERE (Document Type=CONST(Order),
                                                                                                  Document No.=FIELD(Applies-to Doc. No.))
                                                                                                  ELSE IF (Applies-to Doc. Type=CONST(Invoice)) "Sales Line"."Line No." WHERE (Document Type=CONST(Invoice),
                                                                                                                                                                               Document No.=FIELD(Applies-to Doc. No.))
                                                                                                                                                                               ELSE IF (Applies-to Doc. Type=CONST(Return Order)) "Sales Line"."Line No." WHERE (Document Type=CONST(Return Order),
                                                                                                                                                                                                                                                                 Document No.=FIELD(Applies-to Doc. No.))
                                                                                                                                                                                                                                                                 ELSE IF (Applies-to Doc. Type=CONST(Credit Memo)) "Sales Line"."Line No." WHERE (Document Type=CONST(Credit Memo),
                                                                                                                                                                                                                                                                                                                                                  Document No.=FIELD(Applies-to Doc. No.))
                                                                                                                                                                                                                                                                                                                                                  ELSE IF (Applies-to Doc. Type=CONST(Shipment)) "Sales Shipment Line"."Line No." WHERE (Document No.=FIELD(Applies-to Doc. No.))
                                                                                                                                                                                                                                                                                                                                                  ELSE IF (Applies-to Doc. Type=CONST(Return Receipt)) "Return Receipt Line"."Line No." WHERE (Document No.=FIELD(Applies-to Doc. No.));
        }
        field(25006010;"Vehicle Serial No.";Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;

            trigger OnValidate()
            var
                Vehicle: Record "25006005";
                Model: Record "25006001";
                DocumentMgt: Codeunit "25006000";
                FillCustomer: Boolean;
            begin
                CALCFIELDS( VIN, "Make Code", "Model Code", "Model Version No.");   // 09.01.2014 EDMS P15
            end;
        }
        field(25006020;"Vehicle Accounting Cycle No.";Code[20])
        {
            CalcFormula = Lookup("Vehicle Accounting Cycle".No. WHERE (Vehicle Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'Vehicle Accounting Cycle No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006030;VIN;Code[20])
        {
            CalcFormula = Lookup(Vehicle.VIN WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            var
                Vehicle: Record "25006005";
            begin
            end;

            trigger OnValidate()
            var
                recVehicle: Record "25006005";
                bFillCustomer: Boolean;
            begin
            end;
        }
        field(25006040;"Make Code";Code[20])
        {
            CalcFormula = Lookup(Vehicle."Make Code" WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'Make Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006050;"Model Code";Code[20])
        {
            CalcFormula = Lookup(Vehicle."Model Code" WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'Model Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006060;"Model Version No.";Code[20])
        {
            CalcFormula = Lookup(Item.No. WHERE (Item Type=CONST(Model Version),
                                                 Make Code=FIELD(Make Code),
                                                 Model Code=FIELD(Model Code)));
            Caption = 'Model Version No.';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}

