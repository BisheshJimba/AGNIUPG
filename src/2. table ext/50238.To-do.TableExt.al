tableextension 50238 tableextension50238 extends "To-do"
{
    // 19.01.2009. EDMS P2
    //   * Added function ClosedFromForm
    //   * Added code Closed - OnValidate
    // 
    // 30.05.2008. EDMS P2
    //   * Added code CheckDateForHoliday
    fields
    {

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 16)".

        modify("Contact Company No.")
        {
            TableRelation = Contact WHERE(Type = CONST(" "));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Attendees Accepted No."(Field 44)".



        //Unsupported feature: Code Modification on "Closed(Field 13).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF Closed THEN BEGIN
          "Date Closed" := TODAY;
          Status := Status::Completed;
          IF NOT Canceled THEN BEGIN
            IF ("Team Code" <> '') AND
               ("Completed By" = '')
            THEN
              ERROR(STRSUBSTNO(Text029,FIELDCAPTION("Completed By")));
            IF CurrFieldNo <> 0 THEN
              IF CONFIRM(Text004,TRUE) THEN
                CreateInteraction
          END;
          IF Recurring THEN
        #14..19
          IF "Completed By" <> '' THEN
            "Completed By" := ''
        END;
        IF CurrFieldNo <> 0 THEN
          MODIFY(TRUE);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..8
            IF (CurrFieldNo <> 0) OR IsClosedFromForm THEN //19.01.2009. EDMS P2
         //   IF CONFIRM(Text004,TRUE) THEN //09-08-2007 EDMS P3
        #11..22
        IF (CurrFieldNo <> 0)
          OR IsClosedFromForm THEN //19.01.2009. EDMS P2
          MODIFY(TRUE);
        */
        //end;


        //Unsupported feature: Code Modification on ""Interaction Template Code"(Field 37).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF "No." <> '' THEN
          UpdateInteractionTemplate(
            Rec,TodoInteractionLanguage,Attachment,"Interaction Template Code",FALSE);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..3
        IntTempl.GET("Interaction Template Code"); //08-08-2007 EDMS P3
        IF Description = '' THEN                   //08-08-2007 EDMS P3
          Description := IntTempl.Description;     //08-08-2007 EDMS P3
        */
        //end;
        field(25006000; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
        }
        field(25006010; "Service Source Type"; Integer)
        {
            Caption = 'Service Source Type';
        }
        field(25006020; "Service Source ID"; Code[20])
        {
            Caption = 'Service Source ID';

            trigger OnLookup()
            begin
                LookupServiceSourceID
            end;
        }
        field(25006030; VIN; Code[20])
        {
            CalcFormula = Lookup(Vehicle.VIN WHERE(Serial No.=FIELD(Vehicle Serial No.)));
                Caption = 'VIN';
                Editable = false;
                FieldClass = FlowField;
        }
        field(25006040; "Make Code"; Code[20])
        {
            CalcFormula = Lookup(Vehicle."Make Code" WHERE(Serial No.=FIELD(Vehicle Serial No.)));
                Caption = 'Make Code';
                Editable = false;
                FieldClass = FlowField;
        }
        field(25006050; "Model Code"; Code[20])
        {
            CalcFormula = Lookup(Vehicle."Model Code" WHERE(Serial No.=FIELD(Vehicle Serial No.)));
                Caption = 'Model Code';
                Editable = false;
                FieldClass = FlowField;
        }
        field(25006060; "Model Version No."; Code[20])
        {
            CalcFormula = Lookup(Vehicle."Model Version No." WHERE(Serial No.=FIELD(Vehicle Serial No.)));
                Caption = 'Model Version No.';
                Editable = false;
                FieldClass = FlowField;
        }
    }

    //Unsupported feature: Variable Insertion (Variable: Vehicle) (VariableCollection) on "CreateToDoFromToDo(PROCEDURE 1)".



    //Unsupported feature: Code Modification on "CreateToDoFromToDo(PROCEDURE 1)".

    //procedure CreateToDoFromToDo();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    DELETEALL;
    INIT;
    IF ToDo.GETFILTER("Contact Company No.") <> '' THEN
    #4..38
      SETRANGE("Segment No.","Segment No.");
    END;

    StartWizard;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..41
    //07.10.2009. EDMS P2 >>
    IF Vehicle.GET(ToDo.GETFILTER("Vehicle Serial No.")) THEN BEGIN
      "Vehicle Serial No." := Vehicle."Serial No.";
    END;
    //07.10.2009. EDMS P2 <<

    StartWizard;
    */
    //end;

    //Unsupported feature: Variable Insertion (Variable: ToDo2) (VariableCollection) on "CreateInteraction(PROCEDURE 10)".


    //Unsupported feature: Variable Insertion (Variable: LineNo) (VariableCollection) on "CreateInteraction(PROCEDURE 10)".



    //Unsupported feature: Code Modification on "InsertActivityTodo(PROCEDURE 3)".

    //procedure InsertActivityTodo();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    TodoDate := Todo2.Date;
    ActivityStep.SETRANGE("Activity Code",ActivityCode);
    IF ActivityStep.FIND('-') THEN BEGIN
      REPEAT
        InsertActivityStepTodo(Todo2,ActivityStep,TodoDate,Attendee);
      UNTIL ActivityStep.NEXT = 0;
    END ELSE
      InsertActivityStepTodo(Todo2,ActivityStep,TodoDate,Attendee);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    //EDMS1.0.00 >>
    CompanyInformation.GET;
    RMSetup.GET;
    //EDMS1.0.00 <<

    #1..8
    */
    //end;


    //Unsupported feature: Code Modification on "InsertActivityStepTodo(PROCEDURE 22)".

    //procedure InsertActivityStepTodo();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    TodoTemp.INIT;
    TodoTemp := Todo2;
    TodoTemp.INSERT;
    IF NOT ActivityStep.ISEMPTY THEN BEGIN
      TodoTemp.Type := ActivityStep.Type;
      TodoTemp.Priority := ActivityStep.Priority;
      TodoTemp.Description := ActivityStep.Description;
      TodoTemp.Date := CALCDATE(ActivityStep."Date Formula",TodoDate);
    END;

    IF TodoTemp.Type = Type::Meeting THEN BEGIN
      IF NOT Attendee2.ISEMPTY THEN BEGIN
        Attendee2.SETRANGE("Attendance Type",Attendee2."Attendance Type"::"To-do Organizer");
        Attendee2.FIND('-')
      END;
      TempAttendee.DELETEALL;
      TodoTemp.VALIDATE("All Day Event",TRUE);

      InteractionTemplateSetup.GET;
      IF (InteractionTemplateSetup."Meeting Invitation" <> '') AND
         InteractionTemplate.GET(InteractionTemplateSetup."Meeting Invitation")
      THEN
        UpdateInteractionTemplate(
          TodoTemp,TodoInteractionLanguage,TempAttachment,InteractionTemplate.Code,TRUE);

      CreateAttendeesFromTodo(TempAttendee,TodoTemp,Attendee2."Attendee No.");

    #28..38
        TempAttachment,TempAttendee,RMCommentLine);
    END;
    TodoTemp.DELETE;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..8

      //EDMS1.0.00 >>
      CheckDateForHoliday(TodoTemp.Date); //03-08-2007 EDMS P3
      TodoTemp.Location := ActivityStep.Location;  //03-08-2007 EDMS P3
      TodoTemp."Interaction Template Code" := ActivityStep."Interaction Template Code"; //09-08-2007 EDMS P3
      //EDMS1.0.00 <<

    #9..16

      //03-08-2007 EDMS P3 >>
      TodoTemp.VALIDATE("All Day Event",ActivityStep."All Day Event");
      IF NOT ActivityStep."All Day Event" THEN BEGIN
        RMSetup.TESTFIELD("Workday Starting Time");
        TodoTemp.VALIDATE("Start Time",RMSetup."Workday Starting Time");
        TodoTemp.VALIDATE(Duration,ActivityStep.Duration)
      END;

      IF TodoTemp."Interaction Template Code" = '' THEN BEGIN
        InteractionTemplateSetup.GET;
        TodoTemp."Interaction Template Code" := InteractionTemplateSetup."Meeting Invitation"
      END;
      IF InteractionTemplate.GET(TodoTemp."Interaction Template Code") THEN
        UpdateInteractionTemplate(
          TodoTemp,TodoInteractionLanguage,TempAttachment,InteractionTemplate.Code,TRUE);
      //03-08-2007 EDMS P3 <<
    #25..41
    */
    //end;

    procedure CheckDateForHoliday(var ToDoDate: Date)
    var
        CalendarMgt: Codeunit "7600";
        WeekDay: Integer;
        CalendarDescription: Text[50];
        AllDescr: Text[500];
        Hol: Boolean;
        Direct: Text[10];
        InitDate: Date;
        Reason: Text[300];
        Ch: Char;
        Ch2: Text[1];
    begin
        RMSetup.GET;

        //30.05.2008. EDMS P2 >>
        RMSetup.TESTFIELD("Working Week Length");
        //30.05.2008. EDMS P2 <<

        Ch := 13;
        Ch2 := FORMAT(Ch);
        WeekDay := DATE2DWY(ToDoDate, 1);
        Hol := CalendarMgt.CheckDateStatus(CompanyInformation."Base Calendar Code", ToDoDate, CalendarDescription);
        IF (WeekDay > RMSetup."Working Week Length") OR Hol THEN BEGIN
            InitDate := ToDoDate;
            CASE RMSetup."Move To-dos on Non-Working Day" OF
                RMSetup."Move To-dos on Non-Working Day"::Forward:
                    Direct := '+1D';
                RMSetup."Move To-dos on Non-Working Day"::Backward:
                    Direct := '-1D';
            END;
            REPEAT
                IF Hol THEN
                    Reason := Reason + Ch2 + FORMAT(ToDoDate) + ' - ' + CalendarDescription
                ELSE
                    Reason := Reason + Ch2 + FORMAT(ToDoDate) + ' - ' + Text101;
                ToDoDate := CALCDATE(Direct, ToDoDate);
                Hol := CalendarMgt.CheckDateStatus(CompanyInformation."Base Calendar Code", ToDoDate, CalendarDescription);
                WeekDay := DATE2DWY(ToDoDate, 1);
            UNTIL NOT (WeekDay > RMSetup."Working Week Length") AND NOT Hol;
        END
    end;

    procedure CloseFromForm()
    begin
        IsClosedFromForm := TRUE;
    end;

    procedure LookupServiceSourceID()
    var
        ServiceHeader: Record "25006145";
        PostedServiceHeader: Record "25006149";
        PstRetServiceHdr: Record "25006154";
    begin
        CASE "Service Source Type" OF
            DATABASE::"Service Header EDMS":
                BEGIN
                    ServiceHeader."No." := "Service Source ID";
                    IF PAGE.RUNMODAL(0, ServiceHeader) = ACTION::LookupOK THEN
                        "Service Source ID" := ServiceHeader."No.";
                END;
            DATABASE::"Posted Serv. Order Header":
                BEGIN
                    PostedServiceHeader."No." := "Service Source ID";
                    IF PAGE.RUNMODAL(0, PostedServiceHeader) = ACTION::LookupOK THEN
                        "Service Source ID" := PostedServiceHeader."No.";
                END;
            DATABASE::"Posted Serv. Ret. Order Header":
                BEGIN
                    PstRetServiceHdr."No." := "Service Source ID";
                    IF PAGE.RUNMODAL(0, PstRetServiceHdr) = ACTION::LookupOK THEN
                        "Service Source ID" := PstRetServiceHdr."No.";
                END
        END;
    end;

    var
        IntTempl: Record "5064";

    var
        Text101: Label 'day off';
        CompanyInformation: Record "79";

    var
        IsClosedFromForm: Boolean;
}

