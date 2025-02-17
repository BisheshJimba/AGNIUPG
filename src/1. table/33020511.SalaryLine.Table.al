table 33020511 "Salary Line"
{
    // *PAYROLL 6.1.0 YURAN@AGILE*


    fields
    {
        field(1; "Document No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Employee No."; Code[20])
        {
            NotBlank = true;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                IF Rec."Employee No." <> xRec."Employee No." THEN
                    CheckDuplicate;
                TempSalaryLine := Rec;
                INIT;
                "Employee No." := TempSalaryLine."Employee No.";
                Employee.GET("Employee No.");
                CLEAR(PayrollProcessing);
                PayrollProcessing.SetEmployee(Employee);
                PayrollProcessing.GetLeaveEncashAmount(Rec, PayrollProcessing.GetBasicSalary);
                PayrollProcessing.InitSalaryLines(Rec);
                GetSalaryHeader;
                SalaryAdvance(SalaryHeader."Posting Date");
            end;
        }
        field(4; "Basic with Grade"; Decimal)
        {
            Caption = 'Basic with Grade';
            Editable = false;
        }
        field(10; "Net Pay"; Decimal)
        {
            Editable = false;
        }
        field(11; "Taxable Income"; Decimal)
        {
            Editable = false;
        }
        field(12; "Tax for Period"; Decimal)
        {

            trigger OnValidate()
            begin
                //"Net Pay" := "Total Benefit" - "Tax for Period";
            end;
        }
        field(13; "Total Benefit"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                PayrollProcessing.CalcSalary(Rec);
            end;
        }
        field(14; "Total Deduction"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                PayrollProcessing.CalcSalary(Rec);
            end;
        }
        field(15; "Total Employer Contribution"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                PayrollProcessing.CalcSalary(Rec);
            end;
        }
        field(16; "Total Tax Credit"; Decimal)
        {
        }
        field(20; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(21; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(22; Remarks; Text[250])
        {
        }
        field(23; "Present Days"; Decimal)
        {
            Editable = false;
        }
        field(24; "Absent Days"; Decimal)
        {
            Editable = false;
        }
        field(25; "Paid Days"; Decimal)
        {
            Editable = false;
        }
        field(26; "From Date"; Date)
        {
        }
        field(27; "To Date"; Date)
        {
        }
        field(28; Month; Option)
        {
            OptionCaption = ' ,January,February,March,April,May,June,July,August,September,October,November,December';
            OptionMembers = " ",January,February,March,April,May,June,July,August,September,October,November,December;
        }
        field(29; "Non-Payment Adjustment"; Decimal)
        {
            Description = 'for the Non beneficial; increases the annual earning';

            trigger OnValidate()
            begin
                PayrollProcessing.CalcSalary(Rec);
            end;
        }
        field(30; "Last Slab (%)"; Decimal)
        {
        }
        field(31; "Remaining Amount to Cross Slab"; Decimal)
        {
            Editable = false;
        }
        field(32; "Tax Paid on First Account"; Decimal)
        {
        }
        field(33; "Tax Paid on Second Account"; Decimal)
        {
        }
        field(50; "Employee Name"; Text[50])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE(No.=FIELD(Employee No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(51;"Job Title";Text[100])
        {
            CalcFormula = Lookup(Employee."Job Title" WHERE (No.=FIELD(Employee No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(52;Gratuity;Decimal)
        {
            DecimalPlaces = 0:2;
        }
        field(53;"Gratuity TDS Payable";Decimal)
        {
        }
        field(54;"Net Gratuity";Decimal)
        {
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(481;"SSF(1.67 %)";Decimal)
        {
        }
        field(50000;"Leave Encash Days";Decimal)
        {
        }
        field(33020500;"Variable Field 33020500";Decimal)
        {
            CaptionClass = '8,33020511,33020500';
            Editable = false;

            trigger OnValidate()
            begin
                PayrollProcessing.UpdateSalaryLine(Rec,FIELDNO("Variable Field 33020500"),xRec."Variable Field 33020500","Variable Field 33020500"
                );
            end;
        }
        field(33020501;"Variable Field 33020501";Decimal)
        {
            CaptionClass = '8,33020511,33020501';
            Editable = false;

            trigger OnValidate()
            begin
                PayrollProcessing.UpdateSalaryLine(Rec,FIELDNO("Variable Field 33020501"),xRec."Variable Field 33020501","Variable Field 33020501"
                );
            end;
        }
        field(33020502;"Variable Field 33020502";Decimal)
        {
            CaptionClass = '8,33020511,33020502';
            Editable = false;

            trigger OnValidate()
            begin
                PayrollProcessing.UpdateSalaryLine(Rec,FIELDNO("Variable Field 33020502"),xRec."Variable Field 33020502","Variable Field 33020502"
                );
            end;
        }
        field(33020503;"Variable Field 33020503";Decimal)
        {
            CaptionClass = '8,33020511,33020503';

            trigger OnValidate()
            begin
                PayrollProcessing.UpdateSalaryLine(Rec,FIELDNO("Variable Field 33020503"),xRec."Variable Field 33020503","Variable Field 33020503"
                );
            end;
        }
        field(33020504;"Variable Field 33020504";Decimal)
        {
            CaptionClass = '8,33020511,33020504';
            Editable = false;

            trigger OnValidate()
            begin
                PayrollProcessing.UpdateSalaryLine(Rec,FIELDNO("Variable Field 33020504"),xRec."Variable Field 33020504","Variable Field 33020504"
                );
            end;
        }
        field(33020505;"Variable Field 33020505";Decimal)
        {
            CaptionClass = '8,33020511,33020505';

            trigger OnValidate()
            begin
                PayrollProcessing.UpdateSalaryLine(Rec,FIELDNO("Variable Field 33020505"),xRec."Variable Field 33020505","Variable Field 33020505"
                );
            end;
        }
        field(33020506;"Variable Field 33020506";Decimal)
        {
            CaptionClass = '8,33020511,33020506';
            Editable = false;

            trigger OnValidate()
            begin
                PayrollProcessing.UpdateSalaryLine(Rec,FIELDNO("Variable Field 33020506"),xRec."Variable Field 33020506","Variable Field 33020506"
                );
            end;
        }
        field(33020507;"Variable Field 33020507";Decimal)
        {
            CaptionClass = '8,33020511,33020507';
            Editable = false;

            trigger OnValidate()
            begin
                PayrollProcessing.UpdateSalaryLine(Rec,FIELDNO("Variable Field 33020507"),xRec."Variable Field 33020507","Variable Field 33020507"
                );
            end;
        }
        field(33020508;"Variable Field 33020508";Decimal)
        {
            CaptionClass = '8,33020511,33020508';
            Editable = false;

            trigger OnValidate()
            begin
                PayrollProcessing.UpdateSalaryLine(Rec,FIELDNO("Variable Field 33020508"),xRec."Variable Field 33020508","Variable Field 33020508"
                );
            end;
        }
        field(33020509;"Variable Field 33020509";Decimal)
        {
            CaptionClass = '8,33020511,33020509';
            Editable = false;

            trigger OnValidate()
            begin
                PayrollProcessing.UpdateSalaryLine(Rec,FIELDNO("Variable Field 33020509"),xRec."Variable Field 33020509","Variable Field 33020509"
                );
            end;
        }
        field(33020510;"Variable Field 33020510";Decimal)
        {
            CaptionClass = '8,33020511,33020510';
            Editable = false;

            trigger OnValidate()
            begin
                PayrollProcessing.UpdateSalaryLine(Rec,FIELDNO("Variable Field 33020510"),xRec."Variable Field 33020510","Variable Field 33020510"
                );
            end;
        }
        field(33020511;"Variable Field 33020511";Decimal)
        {
            CaptionClass = '8,33020511,33020511';
            Editable = false;

            trigger OnValidate()
            begin
                PayrollProcessing.UpdateSalaryLine(Rec,FIELDNO("Variable Field 33020511"),xRec."Variable Field 33020511","Variable Field 33020511"
                );
            end;
        }
        field(33020512;"Variable Field 33020512";Decimal)
        {
            CaptionClass = '8,33020511,33020512';

            trigger OnValidate()
            begin
                PayrollProcessing.UpdateSalaryLine(Rec,FIELDNO("Variable Field 33020512"),xRec."Variable Field 33020512","Variable Field 33020512"
                );
            end;
        }
        field(33020513;"Variable Field 33020513";Decimal)
        {
            CaptionClass = '8,33020511,33020513';
            Editable = false;

            trigger OnValidate()
            begin
                PayrollProcessing.UpdateSalaryLine(Rec,FIELDNO("Variable Field 33020513"),xRec."Variable Field 33020513","Variable Field 33020513"
                );
            end;
        }
        field(33020514;"Variable Field 33020514";Decimal)
        {
            CaptionClass = '8,33020511,33020514';
            Editable = false;

            trigger OnValidate()
            begin
                PayrollProcessing.UpdateSalaryLine(Rec,FIELDNO("Variable Field 33020514"),xRec."Variable Field 33020514","Variable Field 33020514"
                );
            end;
        }
        field(33020515;"Variable Field 33020515";Decimal)
        {
            CaptionClass = '8,33020511,33020515';
            Editable = false;

            trigger OnValidate()
            begin
                PayrollProcessing.UpdateSalaryLine(Rec,FIELDNO("Variable Field 33020515"),xRec."Variable Field 33020515","Variable Field 33020515"
                );
            end;
        }
        field(33020516;"Variable Field 33020516";Decimal)
        {
            CaptionClass = '8,33020511,33020516';
            Editable = false;

            trigger OnValidate()
            begin
                PayrollProcessing.UpdateSalaryLine(Rec,FIELDNO("Variable Field 33020516"),xRec."Variable Field 33020516","Variable Field 33020516"
                );
            end;
        }
        field(33020517;"Variable Field 33020517";Decimal)
        {
            CaptionClass = '8,33020511,33020517';

            trigger OnValidate()
            begin
                PayrollProcessing.UpdateSalaryLine(Rec,FIELDNO("Variable Field 33020517"),xRec."Variable Field 33020517","Variable Field 33020517"
                );
            end;
        }
        field(33020518;"Variable Field 33020518";Decimal)
        {
            CaptionClass = '8,33020511,33020518';

            trigger OnValidate()
            begin
                PayrollProcessing.UpdateSalaryLine(Rec,FIELDNO("Variable Field 33020518"),xRec."Variable Field 33020518","Variable Field 33020518"
                );
            end;
        }
        field(33020519;"Variable Field 33020519";Decimal)
        {
            CaptionClass = '8,33020511,33020519';

            trigger OnValidate()
            begin
                PayrollProcessing.UpdateSalaryLine(Rec,FIELDNO("Variable Field 33020519"),xRec."Variable Field 33020519","Variable Field 33020519"
                );
            end;
        }
        field(33020520;"Variable Field 33020520";Decimal)
        {
            CaptionClass = '8,33020511,33020520';
        }
        field(33020521;"Variable Field 33020521";Decimal)
        {
            CaptionClass = '8,33020511,33020521';
        }
        field(33020522;"Variable Field 33020522";Decimal)
        {
            CaptionClass = '8,33020511,33020522';
        }
        field(33020523;"Variable Field 33020523";Decimal)
        {
            CaptionClass = '8,33020511,33020523';
        }
        field(33020524;"Variable Field 33020524";Decimal)
        {
            CaptionClass = '8,33020511,33020524';
        }
        field(33020525;"Variable Field 33020525";Decimal)
        {
            CaptionClass = '8,33020511,33020525';
        }
        field(33020526;"Variable Field 33020526";Decimal)
        {
            CaptionClass = '8,33020511,33020526';
        }
        field(33020527;"Variable Field 33020527";Decimal)
        {
            CaptionClass = '8,33020511,33020527';
        }
        field(33020528;"Variable Field 33020528";Decimal)
        {
            CaptionClass = '8,33020511,33020528';
        }
        field(33020529;"Variable Field 33020529";Decimal)
        {
            CaptionClass = '8,33020511,33020529';
        }
        field(33020530;"Variable Field 33020530";Decimal)
        {
            CaptionClass = '8,33020511,33020530';
        }
        field(33020531;"Variable Field 33020531";Decimal)
        {
            CaptionClass = '8,33020511,33020531';
        }
        field(33020532;"Variable Field 33020532";Decimal)
        {
            CaptionClass = '8,33020511,33020532';
        }
        field(33020533;"Variable Field 33020533";Decimal)
        {
            CaptionClass = '8,33020511,33020533';
        }
        field(33020534;"Variable Field 33020534";Decimal)
        {
            CaptionClass = '8,33020511,33020534';
        }
        field(33020535;"Variable Field 33020535";Decimal)
        {
            CaptionClass = '8,33020511,33020535';
        }
        field(33020536;"Variable Field 33020536";Decimal)
        {
            CaptionClass = '8,33020511,33020536';
        }
        field(33020537;"Variable Field 33020537";Decimal)
        {
            CaptionClass = '8,33020511,33020537';
        }
        field(33020538;"Variable Field 33020538";Decimal)
        {
            CaptionClass = '8,33020511,33020538';
        }
        field(33020539;"Variable Field 33020539";Decimal)
        {
            CaptionClass = '8,33020511,33020539';
        }
        field(33020540;"Variable Field 33020540";Decimal)
        {
            CaptionClass = '8,33020511,33020540';
        }
        field(33020543;"Tax Exceeding First Slab";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Document No.","Line No.")
        {
            Clustered = true;
            SumIndexFields = "Net Pay";
        }
        key(Key2;"Document No.","Employee No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        /*TestStatusOpen;
        */

    end;

    trigger OnInsert()
    begin
        TestStatusOpen;
        LOCKTABLE;
    end;

    trigger OnModify()
    begin
        TestStatusOpen;
    end;

    var
        PayrollProcessing: Codeunit "33020503";
        Employee: Record "5200";
        TempSalaryLine: Record "33020511";
        DimMgt: Codeunit "408";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"," ","Salary Plan";
        SalaryHeader: Record "33020510";
        Text000: Label 'Employee %1 aready exists on the Salary Plan %2.';
        TaxLedgEntry: Record "33020521";
        TaxLedgCount: Integer;
        i: Integer;

    [Scope('Internal')]
    procedure ValidateShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    end;

    [Scope('Internal')]
    procedure ShowDimensions()
    begin
        TESTFIELD("Document No.");
        TESTFIELD("Line No.");

        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2 %3',DocumentType::"Salary Plan","Document No.","Line No."));
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Global Dimension 1 Code","Global Dimension 2 Code");
    end;

    local procedure TestStatusOpen()
    begin
        GetSalaryHeader;
        SalaryHeader.TESTFIELD(Status,SalaryHeader.Status::Open);
    end;

    local procedure GetSalaryHeader()
    begin
        TESTFIELD("Document No.");
        SalaryHeader.GET("Document No.");
    end;

    [Scope('Internal')]
    procedure CheckDuplicate()
    var
        SalaryLine: Record "33020511";
    begin
        SalaryLine.RESET;
        SalaryLine.SETRANGE("Document No.","Document No.");
        SalaryLine.SETRANGE("Employee No.","Employee No.");
        SalaryLine.SETFILTER("Line No.",'<>%1',SalaryLine."Line No.");
        IF SalaryLine.FINDFIRST THEN
          ERROR(Text000,"Employee No.","Document No.");
    end;

    [Scope('Internal')]
    procedure SalaryAdvance(PostingDate: Date)
    var
        PayrollCompUsage: Record "33020504";
        GLEntry: Record "17";
        Amount: Decimal;
        PayrollCompUsage1: Record "33020504";
    begin
        //Amount := 0;
        /*
        GLEntry.RESET;
        GLEntry.SETFILTER("G/L Account No.",'110513');
        GLEntry.SETRANGE("Employee Code","Employee No.");
        GLEntry.SETFILTER("Posting Date",'<=%1',PostingDate);
        GLEntry.CALCSUMS(Amount);
        //Agni Aastha UPG
        IF GLEntry.FINDFIRST THEN BEGIN
          REPEAT
            Amount += GLEntry.Amount;
          UNTIL GLEntry.NEXT = 0;
        END;
            //Agni Aastha UPG
        
        IF GLEntry.Amount >0 THEN BEGIN
          PayrollCompUsage.RESET;
          PayrollCompUsage.SETRANGE("Employee No.","Employee No.");
          PayrollCompUsage.SETFILTER("Payroll Component Code",'ADVANCE');
          IF PayrollCompUsage.FINDFIRST THEN BEGIN
            PayrollCompUsage.Amount := GLEntry.Amount;
            PayrollCompUsage.Fixed := TRUE;
            PayrollCompUsage.MODIFY;
           END ELSE BEGIN
            PayrollCompUsage.INIT;
            PayrollCompUsage."Employee No." := "Employee No.";
            PayrollCompUsage.VALIDATE("Payroll Component Code",'ADVANCE');
            PayrollCompUsage.Amount :=  GLEntry.Amount;
            PayrollCompUsage.Fixed :=TRUE;
            PayrollCompUsage.INSERT;
           END;
        END ELSE BEGIN
          PayrollCompUsage1.RESET;
          PayrollCompUsage1.SETRANGE("Employee No.","Employee No.");
          PayrollCompUsage1.SETFILTER("Payroll Component Code",'ADVANCE');
          IF PayrollCompUsage1.FINDFIRST THEN BEGIN
            PayrollCompUsage1.DELETE;
          END;
        END;]*/

    end;
}

