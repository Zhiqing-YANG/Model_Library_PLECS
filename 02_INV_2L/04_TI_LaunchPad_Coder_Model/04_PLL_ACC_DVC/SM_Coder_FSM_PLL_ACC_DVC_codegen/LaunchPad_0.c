/*
 * State machine file for: LaunchPad/State Machine
 * Generated with    : PLECS 4.4.5
 * Generated on      : 5 Aug 2021 18:07:03
 */

typedef double real_t;

#define REAL_MAX                       DBL_MAX
#define REAL_MIN                       DBL_MIN
#define REAL_EPSILON                   DBL_EPSILON
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
  FSM_STATE_S2DVC,
  FSM_STATE_S1PLL,
  FSM_STATE_S9ERROR
};

enum FSM_Transition
{
  FSM_TRANSITION_NONE,
  FSM_TRANSITION_S0IDLE_1,
  FSM_INITIAL_TRANSITION,
  FSM_TRANSITION_S2DVC_1,
  FSM_TRANSITION_S2DVC_2,
  FSM_TRANSITION_S1PLL_1,
  FSM_TRANSITION_S1PLL_2,
  FSM_TRANSITION_S1PLL_3
};

#define FSM_MAX_NUM_TAKEN_TRANSITIONS  1
#define FSM_MAX_NUM_TRIGGERS_PER_STATE 3
#define FSM_PREVIOUS_TRIGGER_VALUES_OFFSET 1
#define CurrentState                   fsm_struct->fsm_discStates[0]
#define TakenTransition(i)             fsm_struct->fsm_takenTransitions[i]
#define PreviousTriggerValue(i)        fsm_struct->fsm_discStates[FSM_PREVIOUS_TRIGGER_VALUES_OFFSET + i]
#define IsMajorStep                    fsm_struct->fsm_isMajorTimeStep
#define CurrentTime                    fsm_struct->fsm_currentTime
#define SetErrorMessage(string)        { *fsm_struct->fsm_errorStatus = (string); }
#define SetWarningMessage(string)

/* input variables */
#define PLL_On                         (*fsm_struct->fsm_inputs[0][0])
#define PLL_Off                        (*fsm_struct->fsm_inputs[1][0])
#define DVC_On                         (*fsm_struct->fsm_inputs[2][0])
#define DVC_Off                        (*fsm_struct->fsm_inputs[3][0])
#define Error                          (*fsm_struct->fsm_inputs[4][0])

/* output variables */
#define EN_PLL                         (*fsm_struct->fsm_outputs[0][0])
#define EN_DVC                         (*fsm_struct->fsm_outputs[1][0])
#define SW_Grid                        (*fsm_struct->fsm_outputs[2][0])
#define State                          (*fsm_struct->fsm_outputs[3][0])
#define UNITS0                         (*fsm_struct->fsm_outputs[4][0])
#define UNITS1                         (*fsm_struct->fsm_outputs[5][0])
#define UNITS2                         (*fsm_struct->fsm_outputs[6][0])
#define UNITS3                         (*fsm_struct->fsm_outputs[7][0])

static void fsm_state_S0Idle_EnterAction(const struct FSM_Struct* fsm_struct)
{
  EN_PLL = 0;
  EN_DVC = 0;
  SW_Grid = 1;
  UNITS0 = 0;
  UNITS1 = 0;
  UNITS2 = 0;
  UNITS3 = 0;
  State = 0;
}

static void fsm_state_S2DVC_EnterAction(const struct FSM_Struct* fsm_struct)
{
  EN_PLL = 1;
  EN_DVC = 1;
  SW_Grid = 1;
  UNITS0 = 1;
  UNITS1 = 1;
  UNITS2 = 0;
  UNITS3 = 0;
  State = 3;
}

static void fsm_state_S1PLL_EnterAction(const struct FSM_Struct* fsm_struct)
{
  EN_PLL = 1;
  EN_DVC = 0;
  SW_Grid = 1;
  UNITS0 = 1;
  UNITS1 = 0;
  UNITS2 = 0;
  UNITS3 = 0;
  State = 1;
}

static void fsm_state_S9Error_EnterAction(const struct FSM_Struct* fsm_struct)
{
  SW_Grid = 0;
  EN_PLL = 0;
  EN_DVC = 0;
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
}

void LaunchPad_0_fsm_output(const struct FSM_Struct *fsm_struct)
{
  if (IsMajorStep) {
    int fsm_i;
    for (fsm_i = 0; fsm_i < FSM_MAX_NUM_TAKEN_TRANSITIONS; fsm_i++) {
      TakenTransition(fsm_i) = FSM_TRANSITION_NONE;
    }

    switch ((int)CurrentState)
    {
     case FSM_STATE_S0IDLE:
      if (PLL_On && !PreviousTriggerValue(0)) {
        TakenTransition(0) = FSM_TRANSITION_S0IDLE_1;
        fsm_state_S1PLL_EnterAction(fsm_struct);
        CurrentState = FSM_STATE_S1PLL;
      }
      break;

     case FSM_STATE_S2DVC:
      if (Error && !PreviousTriggerValue(0)) {
        TakenTransition(0) = FSM_TRANSITION_S2DVC_1;
        fsm_state_S9Error_EnterAction(fsm_struct);
        CurrentState = FSM_STATE_S9ERROR;
      } else if (!DVC_Off && PreviousTriggerValue(1)) {
        TakenTransition(0) = FSM_TRANSITION_S2DVC_2;
        fsm_state_S1PLL_EnterAction(fsm_struct);
        CurrentState = FSM_STATE_S1PLL;
      }
      break;

     case FSM_STATE_S1PLL:
      if (Error && !PreviousTriggerValue(0)) {
        TakenTransition(0) = FSM_TRANSITION_S1PLL_1;
        fsm_state_S9Error_EnterAction(fsm_struct);
        CurrentState = FSM_STATE_S9ERROR;
      } else if (!PLL_Off && PreviousTriggerValue(1)) {
        TakenTransition(0) = FSM_TRANSITION_S1PLL_2;
        fsm_state_S0Idle_EnterAction(fsm_struct);
        CurrentState = FSM_STATE_S0IDLE;
      } else if (DVC_On && !PreviousTriggerValue(2)) {
        TakenTransition(0) = FSM_TRANSITION_S1PLL_3;
        fsm_state_S2DVC_EnterAction(fsm_struct);
        CurrentState = FSM_STATE_S2DVC;
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
      PreviousTriggerValue(0) = (PLL_On);
      break;

     case FSM_STATE_S2DVC:
      PreviousTriggerValue(0) = (Error);
      PreviousTriggerValue(1) = (DVC_Off);
      break;

     case FSM_STATE_S1PLL:
      PreviousTriggerValue(0) = (Error);
      PreviousTriggerValue(1) = (PLL_Off);
      PreviousTriggerValue(2) = (DVC_On);
      break;

     default:
      break;
    }
  }
}
