/*
 * Implementation file for: RCP_EXP_OL_FSM/Circuit/LaunchPad
 * Generated with         : PLECS 4.5.3
 *                          TI2837xS 1.2.3
 * Generated on           : 10 Mar 2021 10:01:58
 */

#include "LaunchPad.h"
#ifndef PLECS_HEADER_LaunchPad_h_
#error The wrong header file "LaunchPad.h" was included. Please check your
#error include path to see whether this file name conflicts with the name
#error of another header file.
#endif                                 /* PLECS_HEADER_LaunchPad_h_ */

#if defined(__GNUC__) && (__GNUC__ > 4)
#   define _ALIGNMENT                  16
#   define _RESTRICT                   __restrict
#   define _ALIGN                      __attribute__((aligned(_ALIGNMENT)))
#   if defined(__clang__)
#      if __has_builtin(__builtin_assume_aligned)
#         define _ASSUME_ALIGNED(a)    __builtin_assume_aligned(a, _ALIGNMENT)
#      else
#         define _ASSUME_ALIGNED(a)    a
#      endif

#   else
#      define _ASSUME_ALIGNED(a)       __builtin_assume_aligned(a, _ALIGNMENT)
#   endif

#else
#   ifndef _RESTRICT
#      define _RESTRICT
#   endif

#   ifndef _ALIGN
#      define _ALIGN
#   endif

#   ifndef _ASSUME_ALIGNED
#      define _ASSUME_ALIGNED(a)       a
#   endif
#endif

#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <math.h>
#include <string.h>
#include "hal.h"
#include "dispatcher.h"
#define PLECSRunTimeError(msg)         LaunchPad_errorStatus = msg

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

static struct FSM_Struct LaunchPad_fsm_struct[1];
static const double LaunchPad_UNCONNECTED = 0;
static double LaunchPad_D_double[1];
static uint32_t LaunchPad_D_uint32_t[1];
void LaunchPad_0_fsm_start(const struct FSM_Struct *fsm_struct);
void LaunchPad_0_fsm_output(const struct FSM_Struct *fsm_struct);
static uint32_t LaunchPad_tickLo;
static int32_t LaunchPad_tickHi;
LaunchPad_BlockOutputs LaunchPad_B;
LaunchPad_ModelStates LaunchPad_X _ALIGN;
const char * LaunchPad_errorStatus;
const double LaunchPad_sampleTime = 5.00000000000000024e-05;
const char * const LaunchPad_checksum =
  "2dbd0d52b218abdc44c4373aa5cb2e964d871221";

/* Target declarations */
void LaunchPad_background(void)
{
}

static void Tasks(void * const aParam)
{
  LaunchPad_step();
}

void LaunchPad_initialize(double time)
{
  double remainder;
  size_t i;
  LaunchPad_errorStatus = NULL;
  LaunchPad_tickHi = floor(time/(4294967296.0*LaunchPad_sampleTime));
  remainder = time - LaunchPad_tickHi*4294967296.0*LaunchPad_sampleTime;
  LaunchPad_tickLo = floor(remainder/LaunchPad_sampleTime + .5);
  remainder -= LaunchPad_tickLo*LaunchPad_sampleTime;
  if (fabs(remainder) > 1e-6*fabs(time)) {
    LaunchPad_errorStatus =
      "Start time must be an integer multiple of the base sample time.";
  }

  /* Target pre-initialization */
  // configure multi-purpose timer 0 at 20000.0 Hz
  {
    DISPR_setupTimer(0, 9500);
  }

  // configure PWM1 at 10000.0 Hz in triangle mode (soc='zp')
  {
    PWM_Params_t *params = HAL_getDefaultPwmParams();
    params->outMode = PWM_OUTPUT_MODE_DUAL;
    params->reg.TBPRD = 2375;
    params->reg.ETSEL.bit.SOCASEL = 3;
    params->reg.TBCTL.bit.CTRMODE = 2;

    // active state is high
    params->reg.DBCTL.bit.POLSEL = 2;
    params->reg.TZSEL.bit.CBC1 = 0;
    params->reg.TZSEL.bit.CBC2 = 0;
    params->reg.TZSEL.bit.CBC3 = 0;
    params->reg.TZSEL.bit.OSHT1 = 0;
    params->reg.TZSEL.bit.OSHT2 = 0;
    params->reg.TZSEL.bit.OSHT3 = 0;
    HAL_setupPwm(0, 1, params);

    // configure deadtime to 3.000000e-06 seconds
    HAL_setPwmDeadtimeCounts(0, 142, 142);

    // PWM sequence starting with active state
    HAL_setPwmSequence(0, 1);
  }

  // configure PWM2 at 10000.0 Hz in triangle mode (soc='zp')
  {
    PWM_Params_t *params = HAL_getDefaultPwmParams();
    params->outMode = PWM_OUTPUT_MODE_DUAL;
    params->reg.TBPRD = 2375;
    params->reg.ETSEL.bit.SOCASEL = 3;
    params->reg.TBCTL.bit.CTRMODE = 2;

    // active state is high
    params->reg.DBCTL.bit.POLSEL = 2;
    params->reg.TZSEL.bit.CBC1 = 0;
    params->reg.TZSEL.bit.CBC2 = 0;
    params->reg.TZSEL.bit.CBC3 = 0;
    params->reg.TZSEL.bit.OSHT1 = 0;
    params->reg.TZSEL.bit.OSHT2 = 0;
    params->reg.TZSEL.bit.OSHT3 = 0;
    HAL_setupPwm(1, 2, params);

    // configure deadtime to 3.000000e-06 seconds
    HAL_setPwmDeadtimeCounts(1, 142, 142);

    // PWM sequence starting with active state
    HAL_setPwmSequence(1, 1);
  }

  // configure PWM3 at 10000.0 Hz in triangle mode (soc='zp')
  {
    PWM_Params_t *params = HAL_getDefaultPwmParams();
    params->outMode = PWM_OUTPUT_MODE_DUAL;
    params->reg.TBPRD = 2375;
    params->reg.ETSEL.bit.SOCASEL = 3;
    params->reg.TBCTL.bit.CTRMODE = 2;

    // active state is high
    params->reg.DBCTL.bit.POLSEL = 2;
    params->reg.TZSEL.bit.CBC1 = 0;
    params->reg.TZSEL.bit.CBC2 = 0;
    params->reg.TZSEL.bit.CBC3 = 0;
    params->reg.TZSEL.bit.OSHT1 = 0;
    params->reg.TZSEL.bit.OSHT2 = 0;
    params->reg.TZSEL.bit.OSHT3 = 0;
    HAL_setupPwm(2, 3, params);

    // configure deadtime to 3.000000e-06 seconds
    HAL_setPwmDeadtimeCounts(2, 142, 142);

    // PWM sequence starting with active state
    HAL_setPwmSequence(2, 1);
  }

  // configure ADC B
  {
    AIN_AdcParams_t *params = HAL_getDefaultAdcParams();
    HAL_setupAdc(0, 1, params);
  }

  // configure SOC0 of ADC-B to measure ADCIN3
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(0, 0, 3, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure SOC1 of ADC-B to measure ADCIN4
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(0, 1, 4, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure SOC2 of ADC-B to measure ADCIN5
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(0, 2, 5, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure ADC C
  {
    AIN_AdcParams_t *params = HAL_getDefaultAdcParams();
    HAL_setupAdc(1, 2, params);
  }

  // configure SOC0 of ADC-C to measure ADCIN2
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(1, 0, 2, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure SOC1 of ADC-C to measure ADCIN3
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(1, 1, 3, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure SOC2 of ADC-C to measure ADCIN4
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(1, 2, 4, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure SOC3 of ADC-C to measure ADCIN5
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(1, 3, 5, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  {
    static int taskId = 0;

    // Task 0 at 2.000000e+04 Hz
    DISPR_registerTask(0, &Tasks, 9500L, (void *)&taskId);
  }

  /* Initialization for Digital In : 'LaunchPad/SW_OLPLL' */
  HAL_setupDigitalIn(0, 95);

  /* Initialization for Triangular Wave Generator : 'LaunchPad/Controller/OL/Triangular Wave' */
  LaunchPad_D_uint32_t[0] = (((int32_t) floor(time/5.00000000000000024e-05+.5) -
    0) % 400 + 400) % 400;

  /* Initialization for State Machine : 'LaunchPad/State Machine' */
  {
    static const double* fsm_inputPtrs[] = { &LaunchPad_B.SW_OLPLL,
      &LaunchPad_B.SW_OLPLL, &LaunchPad_D_double[0] };

    static const double** fsm_inputs[] = { &fsm_inputPtrs[0], &fsm_inputPtrs[1],
      &fsm_inputPtrs[2] };

    static double* fsm_outputPtrs[] = { &LaunchPad_B.StateMachine[0],
      &LaunchPad_B.StateMachine[1], &LaunchPad_B.StateMachine[2],
      &LaunchPad_B.StateMachine[3], &LaunchPad_B.StateMachine[4],
      &LaunchPad_B.StateMachine[5] };

    static double** fsm_outputs[] = { &fsm_outputPtrs[0], &fsm_outputPtrs[1],
      &fsm_outputPtrs[2], &fsm_outputPtrs[3], &fsm_outputPtrs[4],
      &fsm_outputPtrs[5] };

    static int fsm_takenTransitions[1];
    static double fsm_nextSampleHit;
    static const char* fsm_errorStatus = NULL;
    static const char* fsm_warningStatus = NULL;
    LaunchPad_fsm_struct[0].fsm_isMajorTimeStep = 1;
    LaunchPad_fsm_struct[0].fsm_internalConstants = NULL;
    LaunchPad_fsm_struct[0].fsm_inputs = fsm_inputs;
    LaunchPad_fsm_struct[0].fsm_outputs = fsm_outputs;
    LaunchPad_fsm_struct[0].fsm_discStates = &LaunchPad_X.StateMachine[0];
    LaunchPad_fsm_struct[0].fsm_zCSignals = NULL;
    LaunchPad_fsm_struct[0].fsm_takenTransitions = fsm_takenTransitions;
    LaunchPad_fsm_struct[0].fsm_nextSampleHit = &fsm_nextSampleHit;
    LaunchPad_fsm_struct[0].fsm_samplingFrequency = 1.0 / 5e-05;
    LaunchPad_fsm_struct[0].fsm_errorStatus = &fsm_errorStatus;
    LaunchPad_fsm_struct[0].fsm_warningStatus = &fsm_warningStatus;
    LaunchPad_0_fsm_start(&LaunchPad_fsm_struct[0]);
    if (*LaunchPad_fsm_struct[0].fsm_errorStatus)
      LaunchPad_errorStatus = *LaunchPad_fsm_struct[0].fsm_errorStatus;
  }

  /* Initialization for Digital Out : 'LaunchPad/State_Units0' */
  HAL_setupDigitalOut(0, 130, false);

  /* Initialization for Digital Out : 'LaunchPad/State_Units1' */
  HAL_setupDigitalOut(1, 131, false);

  /* Initialization for Digital Out : 'LaunchPad/State_Units2' */
  HAL_setupDigitalOut(2, 66, false);

  /* Initialization for Digital Out : 'LaunchPad/State_Units3' */
  HAL_setupDigitalOut(3, 16, false);
}

void LaunchPad_step(void)
{
  if (LaunchPad_errorStatus) {
    return;
  }

  /* Digital In : 'LaunchPad/SW_OLPLL' */
  LaunchPad_B.SW_OLPLL = HAL_getDigitalIn(0);

  /* Saturation : 'LaunchPad/ADC Decode/Saturation'
   * incorporates
   *  Gain : 'LaunchPad/ADC Decode/Gain'
   *  ADC : 'LaunchPad/ADC C'
   */
  LaunchPad_B.Saturation = 0.5*(HAL_getAnalogInF(1, 0));
  if (LaunchPad_B.Saturation > 1.) {
    LaunchPad_B.Saturation = 1.;
  } else if (LaunchPad_B.Saturation < 0.) {
    LaunchPad_B.Saturation = 0.;
  }

  /* Triangular Wave Generator : 'LaunchPad/Controller/OL/Triangular Wave' */
  {
    double frac;
    frac = LaunchPad_D_uint32_t[0]*((double)1/400);
    LaunchPad_B.TriangularWave = 0.+6.28318530717958623*frac;
  }

  /* Trigonometric Function : 'LaunchPad/Controller/OL/RRF->3ph/Cos' */
  LaunchPad_B.Cos = cos(LaunchPad_B.TriangularWave);

  /* Trigonometric Function : 'LaunchPad/Controller/OL/RRF->3ph/Sin' */
  LaunchPad_B.Sin = sin(LaunchPad_B.TriangularWave);

  /* Function : 'LaunchPad/Controller/OL/RRF->3ph/dq->a'
   * incorporates
   *  Constant : 'LaunchPad/Controller/OL/Index_q_ref'
   */
  LaunchPad_B.dq_a = (LaunchPad_B.Saturation * LaunchPad_B.Cos) - (0. *
    LaunchPad_B.Sin);

  /* Function : 'LaunchPad/Controller/OL/RRF->3ph/dq->b'
   * incorporates
   *  Constant : 'LaunchPad/Controller/OL/Index_q_ref'
   */
  LaunchPad_B.dq_b = (LaunchPad_B.Saturation * ((-0.5 * LaunchPad_B.Cos) +
    (0.866025403784438597 * LaunchPad_B.Sin))) + (0. * ((0.5 * LaunchPad_B.Sin)
    + (0.866025403784438597 * LaunchPad_B.Cos)));

  /* State Machine : 'LaunchPad/State Machine' */
  LaunchPad_D_double[0] = ((fabs((((HAL_getAnalogInF(1, 1)) -
    1.49700000000000011) - -0.00300000000000000006) * 183.447988326037091) >=
    130.) || (fabs((((HAL_getAnalogInF(1, 2)) - 1.49700000000000011) -
                    -0.00300000000000000006) * 183.447988326037091) >= 130.) ||
    (fabs((((HAL_getAnalogInF(1, 3)) - 1.49700000000000011) -
           -0.00300000000000000006) * 183.447988326037091) >= 130.)) || ((fabs
    ((((HAL_getAnalogInF(0, 0)) - 1.49700000000000011) - -0.0100000000000000002)
     * 14.1904356463743433) >= 20.) || (fabs((((HAL_getAnalogInF(0, 1)) -
    1.49700000000000011) - -0.0100000000000000002) * 14.1904356463743433) >= 20.)
    || (fabs((((HAL_getAnalogInF(0, 2)) - 1.49700000000000011) - 0.) *
             14.1904356463743433) >= 20.));
  LaunchPad_0_fsm_output(&LaunchPad_fsm_struct[0]);
  if (*LaunchPad_fsm_struct[0].fsm_errorStatus)
    LaunchPad_errorStatus = *LaunchPad_fsm_struct[0].fsm_errorStatus;

  /* Signal Switch : 'LaunchPad/Controller/output selector/Switch1' */
  LaunchPad_B.Switch1 = LaunchPad_B.StateMachine[0] != 0.;

  /* PWM  : 'LaunchPad/PWM' */
  HAL_setPwmDuty(0, LaunchPad_B.Switch1 ? ((0.5*LaunchPad_B.dq_a) + 0.5) : 0.);
  HAL_setPwmDuty(1, LaunchPad_B.Switch1 ? ((0.5*LaunchPad_B.dq_b) + 0.5) : 0.);
  HAL_setPwmDuty(2, LaunchPad_B.Switch1 ? ((0.5*(-LaunchPad_B.dq_b -
    LaunchPad_B.dq_a)) + 0.5) : 0.);

  /* Digital Out : 'LaunchPad/State_Units0' */
  HAL_setDigitalOut(0, LaunchPad_B.StateMachine[2]);

  /* Digital Out : 'LaunchPad/State_Units1' */
  HAL_setDigitalOut(1, LaunchPad_B.StateMachine[3]);

  /* Digital Out : 'LaunchPad/State_Units2' */
  HAL_setDigitalOut(2, LaunchPad_B.StateMachine[4]);

  /* Digital Out : 'LaunchPad/State_Units3' */
  HAL_setDigitalOut(3, LaunchPad_B.StateMachine[5]);
  if (LaunchPad_errorStatus) {
    return;
  }

  /* Update for Triangular Wave Generator : 'LaunchPad/Controller/OL/Triangular Wave' */
  LaunchPad_D_uint32_t[0] += 1;
  if (LaunchPad_D_uint32_t[0] > 399) {
    LaunchPad_D_uint32_t[0] = 0;
  }
}

void LaunchPad_terminate()
{
}
