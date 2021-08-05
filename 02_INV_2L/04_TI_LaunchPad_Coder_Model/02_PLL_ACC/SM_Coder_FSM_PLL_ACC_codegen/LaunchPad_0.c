/*
 * State machine file for: LaunchPad/State Machine
 * Generated with    : PLECS 4.4.5
 * Generated on      : 5 Aug 2021 17:46:50
 */

typedef double real_t;

#define REAL_MAX                       DBL_MAX
#define REAL_MIN                       DBL_MIN
#define REAL_EPSILON                   DBL_EPSILON
#include <float.h>
#include <math.h>
#include <math.h>                      /* fabs */

struct FSM_Struct {
  int fsm_isMajorTimeStep;
  double fsm_currentTime;
  const double *fsm_internalConstants;
  const double ***fsm_inputs;
  double ***fsm_outputs;
  double *fsm_discStates;
  double *fsm_zCSignals;
  int *fsm_takenTransitions;
  double *fsm_nextSampleHit;
  double fsm_samplingFrequency;
  const char **fsm_errorStatus;
  const char **fsm_warningStatus;
};

enum FSM_State
{
  FSM_STATE_NONE,
  FSM_STATE_S0IDLE,
  FSM_STATE_S2GRIDFOLLOWING,
  FSM_STATE_S3CLACC,
  FSM_STATE_S8SHUTDOWN,
  FSM_STATE_S1GRIDFORMING,
  FSM_STATE_S9ERROR
};

enum FSM_Transition
{
  FSM_TRANSITION_NONE,
  FSM_TRANSITION_S0IDLE_1,
  FSM_INITIAL_TRANSITION,
  FSM_TRANSITION_S2GRIDFOLLOWING_1,
  FSM_TRANSITION_S2GRIDFOLLOWING_2,
  FSM_TRANSITION_S2GRIDFOLLOWING_3,
  FSM_TRANSITION_S3CLACC_1,
  FSM_TRANSITION_S3CLACC_2,
  FSM_TRANSITION_S3CLACC_3,
  FSM_TRANSITION_S8SHUTDOWN_1,
  FSM_TRANSITION_S8SHUTDOWN_2,
  FSM_TRANSITION_S1GRIDFORMING_1,
  FSM_TRANSITION_S1GRIDFORMING_2,
  FSM_TRANSITION_S1GRIDFORMING_3
};

#define FSM_MAX_NUM_TAKEN_TRANSITIONS  1
#define FSM_MAX_NUM_TRIGGERS_PER_STATE 3
#define FSM_MAX_NUM_ACTIVE_AFTER_TRIGGERS 1
#define FSM_PREVIOUS_TRIGGER_VALUES_OFFSET 1
#define FSM_AFTER_TRIGGER_TIMESTAMPS_OFFSET FSM_PREVIOUS_TRIGGER_VALUES_OFFSET + FSM_MAX_NUM_TRIGGERS_PER_STATE
#define CurrentState                   fsm_struct->fsm_discStates[0]
#define TakenTransition(i)             fsm_struct->fsm_takenTransitions[i]
#define PreviousTriggerValue(i)        fsm_struct->fsm_discStates[FSM_PREVIOUS_TRIGGER_VALUES_OFFSET + i]
#define AfterTriggerTimestamp(i)       fsm_struct->fsm_discStates[FSM_AFTER_TRIGGER_TIMESTAMPS_OFFSET + i]
#define SamplingFrequency              fsm_struct->fsm_samplingFrequency
#define IsMajorStep                    fsm_struct->fsm_isMajorTimeStep
#define CurrentTime                    fsm_struct->fsm_currentTime
#define SetErrorMessage(string)        { *fsm_struct->fsm_errorStatus = (string); }
#define SetWarningMessage(string)

/* input variables */
#define Start_Up                       (*fsm_struct->fsm_inputs[0][0])
#define Shut_Down                      (*fsm_struct->fsm_inputs[1][0])
#define ACC_On                         (*fsm_struct->fsm_inputs[2][0])
#define ACC_Off                        (*fsm_struct->fsm_inputs[3][0])
#define Error                          (*fsm_struct->fsm_inputs[4][0])

/* output variables */
#define EN_OLPLL                       (*fsm_struct->fsm_outputs[0][0])
#define EN_ACC                         (*fsm_struct->fsm_outputs[1][0])
#define SW_Grid                        (*fsm_struct->fsm_outputs[2][0])
#define State                          (*fsm_struct->fsm_outputs[3][0])
#define UNITS0                         (*fsm_struct->fsm_outputs[4][0])
#define UNITS1                         (*fsm_struct->fsm_outputs[5][0])
#define UNITS2                         (*fsm_struct->fsm_outputs[6][0])
#define UNITS3                         (*fsm_struct->fsm_outputs[7][0])

static void fsm_checkAfterTriggerOverflow(const struct FSM_Struct *fsm_struct,
  double fsm_value)
{
  if (fsm_value - (fsm_value - 1.0) != 1.0) {
    SetErrorMessage("Error: AFTER trigger expression overflow.");
  }
}

static void fsm_state_S0Idle_EnterAction(const struct FSM_Struct* fsm_struct)
{
  EN_OLPLL = 0;
  EN_ACC = 0;
  SW_Grid = 0;
  UNITS0 = 0;
  UNITS1 = 0;
  UNITS2 = 0;
  UNITS3 = 0;
  State = 0;
}

static void fsm_state_S2GridFollowing_EnterAction(const struct FSM_Struct*
  fsm_struct)
{
  EN_OLPLL = 1;
  EN_ACC = 0;
  SW_Grid = 1;
  UNITS0 = 0;
  UNITS1 = 1;
  UNITS2 = 0;
  UNITS3 = 0;
  State = 2;
}

static void fsm_state_S3CLACC_EnterAction(const struct FSM_Struct* fsm_struct)
{
  EN_OLPLL = 1;
  EN_ACC = 1;
  SW_Grid = 1;
  UNITS0 = 1;
  UNITS1 = 1;
  UNITS2 = 0;
  UNITS3 = 0;
  State = 3;
}

static void fsm_state_S8ShutDown_EnterAction(const struct FSM_Struct* fsm_struct)
{
  EN_OLPLL = 1;
  EN_ACC = 0;
  SW_Grid = 1;
  UNITS0 = 0;
  UNITS1 = 0;
  UNITS2 = 0;
  UNITS3 = 1;
  State = 8;
}

static void fsm_state_S1GridForming_EnterAction(const struct FSM_Struct*
  fsm_struct)
{
  EN_OLPLL = 1;
  EN_ACC = 0;
  SW_Grid = 0;
  UNITS0 = 1;
  UNITS1 = 0;
  UNITS2 = 0;
  UNITS3 = 0;
  State = 1;
}

static void fsm_state_S9Error_EnterAction(const struct FSM_Struct* fsm_struct)
{
  SW_Grid = 0;
  EN_OLPLL = 0;
  EN_ACC = 0;
  UNITS0 = 1;
  UNITS1 = 0;
  UNITS2 = 0;
  UNITS3 = 1;
  State = 9;
}

void LaunchPad_0_fsm_start(const struct FSM_Struct *fsm_struct)
{
  int fsm_i;
  CurrentState = FSM_STATE_NONE;
  for (fsm_i = 0; fsm_i < FSM_MAX_NUM_TAKEN_TRANSITIONS; fsm_i++) {
    TakenTransition(fsm_i) = FSM_TRANSITION_NONE;
  }

  for (fsm_i = 0; fsm_i < FSM_MAX_NUM_TRIGGERS_PER_STATE; fsm_i++) {
    PreviousTriggerValue(fsm_i) = 0;
  }

  for (fsm_i = 0; fsm_i < FSM_MAX_NUM_ACTIVE_AFTER_TRIGGERS; fsm_i++) {
    AfterTriggerTimestamp(fsm_i) = DBL_MAX;
  }
}

void LaunchPad_0_fsm_output(const struct FSM_Struct *fsm_struct)
{
  if (IsMajorStep) {
    int fsm_numActiveAfterTriggers = 0;
    int fsm_i;
    for (fsm_i = 0; fsm_i < FSM_MAX_NUM_TAKEN_TRANSITIONS; fsm_i++) {
      TakenTransition(fsm_i) = FSM_TRANSITION_NONE;
    }

    switch ((int)CurrentState)
    {
     case FSM_STATE_S0IDLE:
      if (Start_Up && !PreviousTriggerValue(0)) {
        TakenTransition(0) = FSM_TRANSITION_S0IDLE_1;
        fsm_state_S1GridForming_EnterAction(fsm_struct);
        AfterTriggerTimestamp(0) = ceil((10) * SamplingFrequency);
        fsm_checkAfterTriggerOverflow(fsm_struct, AfterTriggerTimestamp(0));
        CurrentState = FSM_STATE_S1GRIDFORMING;
      }
      break;

     case FSM_STATE_S2GRIDFOLLOWING:
      if (Error && !PreviousTriggerValue(0)) {
        TakenTransition(0) = FSM_TRANSITION_S2GRIDFOLLOWING_1;
        fsm_state_S9Error_EnterAction(fsm_struct);
        CurrentState = FSM_STATE_S9ERROR;
      } else if (!Shut_Down && PreviousTriggerValue(1)) {
        TakenTransition(0) = FSM_TRANSITION_S2GRIDFOLLOWING_2;
        fsm_state_S0Idle_EnterAction(fsm_struct);
        CurrentState = FSM_STATE_S0IDLE;
      } else if (ACC_On && !PreviousTriggerValue(2)) {
        TakenTransition(0) = FSM_TRANSITION_S2GRIDFOLLOWING_3;
        fsm_state_S3CLACC_EnterAction(fsm_struct);
        CurrentState = FSM_STATE_S3CLACC;
      }
      break;

     case FSM_STATE_S3CLACC:
      if (Error && !PreviousTriggerValue(0)) {
        TakenTransition(0) = FSM_TRANSITION_S3CLACC_1;
        fsm_state_S9Error_EnterAction(fsm_struct);
        CurrentState = FSM_STATE_S9ERROR;
      } else if (!Shut_Down && PreviousTriggerValue(1)) {
        TakenTransition(0) = FSM_TRANSITION_S3CLACC_2;
        fsm_state_S8ShutDown_EnterAction(fsm_struct);
        AfterTriggerTimestamp(0) = ceil((10) * SamplingFrequency);
        fsm_checkAfterTriggerOverflow(fsm_struct, AfterTriggerTimestamp(0));
        CurrentState = FSM_STATE_S8SHUTDOWN;
      } else if (!ACC_Off && PreviousTriggerValue(2)) {
        TakenTransition(0) = FSM_TRANSITION_S3CLACC_3;
        fsm_state_S2GridFollowing_EnterAction(fsm_struct);
        CurrentState = FSM_STATE_S2GRIDFOLLOWING;
      }
      break;

     case FSM_STATE_S8SHUTDOWN:
      if (Error && !PreviousTriggerValue(0)) {
        TakenTransition(0) = FSM_TRANSITION_S8SHUTDOWN_1;
        fsm_state_S9Error_EnterAction(fsm_struct);
        CurrentState = FSM_STATE_S9ERROR;
      } else if ((AfterTriggerTimestamp(0) <= 0) && !PreviousTriggerValue(1)) {
        TakenTransition(0) = FSM_TRANSITION_S8SHUTDOWN_2;
        fsm_state_S0Idle_EnterAction(fsm_struct);
        CurrentState = FSM_STATE_S0IDLE;
      }
      break;

     case FSM_STATE_S1GRIDFORMING:
      if (Error && !PreviousTriggerValue(0)) {
        TakenTransition(0) = FSM_TRANSITION_S1GRIDFORMING_1;
        fsm_state_S9Error_EnterAction(fsm_struct);
        CurrentState = FSM_STATE_S9ERROR;
      } else if (!Shut_Down && PreviousTriggerValue(1)) {
        TakenTransition(0) = FSM_TRANSITION_S1GRIDFORMING_2;
        fsm_state_S0Idle_EnterAction(fsm_struct);
        CurrentState = FSM_STATE_S0IDLE;
      } else if ((AfterTriggerTimestamp(0) <= 0) && !PreviousTriggerValue(2)) {
        TakenTransition(0) = FSM_TRANSITION_S1GRIDFORMING_3;
        fsm_state_S2GridFollowing_EnterAction(fsm_struct);
        CurrentState = FSM_STATE_S2GRIDFOLLOWING;
      }
      break;

     case FSM_STATE_S9ERROR:
      break;

     default:
      TakenTransition(0) = FSM_INITIAL_TRANSITION;
      fsm_state_S0Idle_EnterAction(fsm_struct);
      CurrentState = FSM_STATE_S0IDLE;
      break;
    }

    switch ((int)CurrentState)
    {
     case FSM_STATE_S0IDLE:
      PreviousTriggerValue(0) = (Start_Up);
      break;

     case FSM_STATE_S2GRIDFOLLOWING:
      PreviousTriggerValue(0) = (Error);
      PreviousTriggerValue(1) = (Shut_Down);
      PreviousTriggerValue(2) = (ACC_On);
      break;

     case FSM_STATE_S3CLACC:
      PreviousTriggerValue(0) = (Error);
      PreviousTriggerValue(1) = (Shut_Down);
      PreviousTriggerValue(2) = (ACC_Off);
      break;

     case FSM_STATE_S8SHUTDOWN:
      PreviousTriggerValue(0) = (Error);
      PreviousTriggerValue(1) = (AfterTriggerTimestamp(0) <= 0);
      fsm_numActiveAfterTriggers = 1;
      break;

     case FSM_STATE_S1GRIDFORMING:
      PreviousTriggerValue(0) = (Error);
      PreviousTriggerValue(1) = (Shut_Down);
      PreviousTriggerValue(2) = (AfterTriggerTimestamp(0) <= 0);
      fsm_numActiveAfterTriggers = 1;
      break;

     default:
      break;
    }

    for (fsm_i = 0; fsm_i < fsm_numActiveAfterTriggers; fsm_i++) {
      --AfterTriggerTimestamp(fsm_i);
    }
  }
}
