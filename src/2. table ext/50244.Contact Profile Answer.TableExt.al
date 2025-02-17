tableextension 50244 tableextension50244 extends "Contact Profile Answer"
{
    // 09-08-2007 EDMS P3
    //   * New flowfield - comment to access to comments of answer
    // 10-08-2007 EDMS P3
    //   * Deleteing of unneded comments
    fields
    {
        modify("Contact Company No.")
        {
            TableRelation = Contact WHERE(Type = CONST(" "));
        }
        modify("Line No.")
        {
            TableRelation = "Profile Questionnaire Line"."Line No." WHERE(Profile Questionnaire Code=FIELD(Profile Questionnaire Code),
                                                                           Type=CONST(Answer));
        }

        //Unsupported feature: Property Modification (CalcFormula) on "Answer(Field 5)".

        field(25006000; Comment; Date)
        {
            CalcFormula = Max("Profile Answer Comment Line".Date WHERE(Contact No.=FIELD(Contact No.),
                                                                        Profile Questionnaire Code =FIELD(Profile Questionnaire Code),
                                                                        Answer Line No.=FIELD(Line No.)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
    }


    //Unsupported feature: Code Insertion (VariableCollection) on "OnDelete".

    //trigger (Variable: AnswerComments)()
    //Parameters and return type have not been exported.
    //begin
        /*
        */
    //end;


    //Unsupported feature: Code Modification on "OnDelete".

    //trigger OnDelete()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        ProfileQuestnLine.GET("Profile Questionnaire Code",QuestionLineNo);
        ProfileQuestnLine.TESTFIELD("Auto Contact Classification",FALSE);

        #4..6
          INSERT;
        END;

        TouchContact("Contact No.");
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..9
        //10-08-2007 EDMS P3 >>
        AnswerComments.SETRANGE("Contact No.","Contact No.");
        AnswerComments.SETRANGE("Profile Questionnaire Code","Profile Questionnaire Code");
        AnswerComments.SETRANGE("Answer Line No.","Line No.");
        AnswerComments.DELETEALL;
        //10-08-2007 EDMS P3 <<

        TouchContact("Contact No.");
        */
    //end;

    var
        AnswerComments: Record "25006572";
}

