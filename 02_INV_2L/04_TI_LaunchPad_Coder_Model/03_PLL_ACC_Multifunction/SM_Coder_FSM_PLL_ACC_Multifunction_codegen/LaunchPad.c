/*
 * Implementation file for: SM_Coder_FSM_PLL_ACC_Multifunction/Circuit/LaunchPad
 * Generated with         : PLECS 4.4.5
 *                          TI2837xS 1.2
 * Generated on           : 5 Aug 2021 17:57:03
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
static const uint32_t LaunchPad_subTaskPeriod[1]= {
  /* [0.0002, 0], [0, 0] */
  4
};

static uint32_t LaunchPad_subTaskTick[1];
static char LaunchPad_subTaskHit[1];
static const double LaunchPad_UNCONNECTED = 0;
static double LaunchPad_D_double[1];
static double LaunchPad_deriv[12] _ALIGN;
void LaunchPad_0_fsm_start(const struct FSM_Struct *fsm_struct);
void LaunchPad_0_fsm_output(const struct FSM_Struct *fsm_struct);
static uint32_t LaunchPad_tickLo;
static int32_t LaunchPad_tickHi;
LaunchPad_BlockOutputs LaunchPad_B;
LaunchPad_ModelStates LaunchPad_X _ALIGN;
const char * LaunchPad_errorStatus;
const double LaunchPad_sampleTime = 5.00000000000000024e-05;
const char * const LaunchPad_checksum =
  "dba33de78f33b2a8c68d00d387b5180aa30c1ca6";

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

  /* Initialize sub-task tick counters */
  LaunchPad_subTaskTick[0] = 0;        /* [0, 0], [0.0002, 0] */

  /* Offset sub-task tick counters */
  {
    uint32_t i, n, N, delta;
    N = abs(LaunchPad_tickHi);
    for (i = 0; i < 1; ++i) {
      delta = -LaunchPad_subTaskPeriod[i];
      delta %= LaunchPad_subTaskPeriod[i];
      if (LaunchPad_tickHi < 0) {
        delta = LaunchPad_subTaskPeriod[i] - delta;
      }

      for (n = 0; n < N; ++n) {
        LaunchPad_subTaskTick[i] = (LaunchPad_subTaskTick[i] + delta) %
          LaunchPad_subTaskPeriod[i];
      }

      LaunchPad_subTaskTick[i] = (LaunchPad_subTaskTick[i] + LaunchPad_tickLo %
        LaunchPad_subTaskPeriod[i]) % LaunchPad_subTaskPeriod[i];
    }
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
    HAL_setupAdc(1, 1, params);
  }

  // configure SOC0 of ADC-B to measure ADCIN2
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(1, 0, 2, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure SOC1 of ADC-B to measure ADCIN3
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(1, 1, 3, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure SOC2 of ADC-B to measure ADCIN4
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(1, 2, 4, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure SOC3 of ADC-B to measure ADCIN5
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(1, 3, 5, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure ADC C
  {
    AIN_AdcParams_t *params = HAL_getDefaultAdcParams();
    HAL_setupAdc(0, 2, params);
  }

  // configure SOC0 of ADC-C to measure ADCIN2
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(0, 0, 2, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure SOC1 of ADC-C to measure ADCIN3
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(0, 1, 3, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure SOC2 of ADC-C to measure ADCIN4
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(0, 2, 4, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure SOC3 of ADC-C to measure ADCIN5
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(0, 3, 5, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure ADC D
  {
    AIN_AdcParams_t *params = HAL_getDefaultAdcParams();
    HAL_setupAdc(2, 3, params);
  }

  // configure SOC0 of ADC-D to measure ADCIN0
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(2, 0, 0, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure SOC1 of ADC-D to measure ADCIN1
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(2, 1, 1, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure SOC2 of ADC-D to measure ADCIN2
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(2, 2, 2, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure SOC3 of ADC-D to measure ADCIN3
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(2, 3, 3, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure DAC 1
  {
    HAL_setupDac(1, 1, 2.500000000e-01f,1.350000000e+00f,0.000000000e+00f,
                 3.000000000e+00f );
  }

  // configure DAC 0
  {
    HAL_setupDac(0, 0, 2.500000000e-01f,0.000000000e+00f,0.000000000e+00f,
                 3.000000000e+00f );
  }

  {
    static int taskId = 0;

    // Task 0 at 2.000000e+04 Hz
    DISPR_registerTask(0, &Tasks, 9500L, (void *)&taskId);
  }

  /* Initialization for Integrator : 'LaunchPad/Controller/SRF Phas-Locked Loop/Integrator' */
  LaunchPad_X.Integrator_x = 0.;

  /* Initialization for Transfer Function : 'LaunchPad/Controller/Alternating-Current Control2/AD 2/HPF' */
  LaunchPad_X.HPF[0] = 0.;
  LaunchPad_X.HPF[1] = 0.;

  /* Initialization for Digital In : 'LaunchPad/SW_AD_2' */
  HAL_setupDigitalIn(0, 15);

  /* Initialization for Transfer Function : 'LaunchPad/Controller/Alternating-Current Control2/VFF/LPF' */
  LaunchPad_X.LPF[0] = 0.;
  LaunchPad_X.LPF[1] = 0.;

  /* Initialization for Digital In : 'LaunchPad/SW_VFF' */
  HAL_setupDigitalIn(1, 65);

  /* Initialization for Digital In : 'LaunchPad/SW_OLPLL' */
  HAL_setupDigitalIn(2, 95);

  /* Initialization for Digital In : 'LaunchPad/SW_ACC' */
  HAL_setupDigitalIn(3, 139);

  /* Initialization for Digital In : 'LaunchPad/SW_CTRL_BW' */
  HAL_setupDigitalIn(4, 97);

  /* Initialization for Digital In : 'LaunchPad/SW_OPTION_BW' */
  HAL_setupDigitalIn(5, 52);

  /* Initialization for State Machine : 'LaunchPad/State Machine' */
  {
    static const double* fsm_inputPtrs[] = { &LaunchPad_D_double[0],
      &LaunchPad_B.SW_OLPLL, &LaunchPad_B.SW_OLPLL, &LaunchPad_B.SW_ACC,
      &LaunchPad_B.SW_ACC, &LaunchPad_B.SW_CTRL_BW, &LaunchPad_B.SW_CTRL_BW,
      &LaunchPad_B.SW_OPTION_BW };

    static const double** fsm_inputs[] = { &fsm_inputPtrs[0], &fsm_inputPtrs[1],
      &fsm_inputPtrs[2], &fsm_inputPtrs[3], &fsm_inputPtrs[4], &fsm_inputPtrs[5],
      &fsm_inputPtrs[6], &fsm_inputPtrs[7] };

    static double* fsm_outputPtrs[] = { &LaunchPad_B.StateMachine[0],
      &LaunchPad_B.StateMachine[1], &LaunchPad_B.StateMachine[2],
      &LaunchPad_B.StateMachine[3], &LaunchPad_B.StateMachine[4],
      &LaunchPad_B.StateMachine[5], &LaunchPad_B.StateMachine[6],
      &LaunchPad_B.StateMachine[7], &LaunchPad_B.StateMachine[8],
      &LaunchPad_B.StateMachine[9] };

    static double** fsm_outputs[] = { &fsm_outputPtrs[0], &fsm_outputPtrs[1],
      &fsm_outputPtrs[2], &fsm_outputPtrs[3], &fsm_outputPtrs[4],
      &fsm_outputPtrs[5], &fsm_outputPtrs[6], &fsm_outputPtrs[7],
      &fsm_outputPtrs[8], &fsm_outputPtrs[9] };

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

  /* Initialization for Transfer Function : 'LaunchPad/Controller/Alternating-Current Control2/VDC_derivative/HPF' */
  LaunchPad_X.HPF_1[0] = 0.;
  LaunchPad_X.HPF_1[1] = 0.;

  /* Initialization for Digital In : 'LaunchPad/SW_AD_3' */
  HAL_setupDigitalIn(6, 14);

  /* Initialization for Integrator : 'LaunchPad/Controller/Alternating-Current Control2/dd-axis\nVirtual Damping Control/Integrator' */
  LaunchPad_X.Integrator_1_x = 0.;

  /* Initialization for Digital In : 'LaunchPad/SW_VDC' */
  HAL_setupDigitalIn(7, 94);

  /* Initialization for Integrator : 'LaunchPad/Controller/Alternating-Current Control2/d-axis\nPI Regulator/Integrator' */
  LaunchPad_X.Integrator_2_x = 0.;

  /* Initialization for Integrator : 'LaunchPad/Controller/Alternating-Current Control2/qq-axis\nVirtual Damping Control/Integrator' */
  LaunchPad_X.Integrator_3_x = 0.;

  /* Initialization for Integrator : 'LaunchPad/Controller/Alternating-Current Control2/q-axis\nPI Regulator/Integrator' */
  LaunchPad_X.Integrator_4_x = 0.;

  /* Initialization for Delay : 'LaunchPad/Delay' */
  LaunchPad_X.Delay[0] = 0.;
  LaunchPad_X.Delay[1] = 0.;
  LaunchPad_X.Delay[2] = 0.;

  /* Initialization for Digital In : 'LaunchPad/SW_DELAY' */
  HAL_setupDigitalIn(8, 56);

  /* Initialization for Digital Out : 'LaunchPad/Contactor' */
  HAL_setupDigitalOut(0, 19, false);

  /* Initialization for Digital Out : 'LaunchPad/State_Units0' */
  HAL_setupDigitalOut(1, 130, false);

  /* Initialization for Digital Out : 'LaunchPad/State_Units1' */
  HAL_setupDigitalOut(2, 131, false);

  /* Initialization for Digital Out : 'LaunchPad/State_Units2' */
  HAL_setupDigitalOut(3, 66, false);

  /* Initialization for Digital Out : 'LaunchPad/State_Units3' */
  HAL_setupDigitalOut(4, 16, false);

  /* Initialization for Integrator : 'LaunchPad/Controller/SRF Phas-Locked Loop/PLL\nPI Regulator/Integrator' */
  LaunchPad_X.Integrator_5_x = 0.;
}

void LaunchPad_step()
{
  if (LaunchPad_errorStatus) {
    return;
  }

  {
    size_t i;
    for (i = 0; i < 1; ++i) {
      LaunchPad_subTaskHit[i] = (LaunchPad_subTaskTick[i] == 0);
    }
  }

  /* Function : 'LaunchPad/ADC Decode/Calibration/With calibration/Fcn3'
   * incorporates
   *  ADC : 'LaunchPad/ADC C'
   */
  LaunchPad_B.Fcn3 = ((HAL_getAnalogInF(0, 1)) - 1.4980500000000001) /
    0.00534559999999999983;

  /* Integrator : 'LaunchPad/Controller/SRF Phas-Locked Loop/Integrator' */
  LaunchPad_B.Integrator = LaunchPad_X.Integrator_x;

  /* Compare to Constant : 'LaunchPad/Controller/SRF Phas-Locked Loop/Compare to\nConstant' */
  LaunchPad_B.CompareToConstant = LaunchPad_B.Integrator >= 6.28318530717958623;

  /* Integrator : 'LaunchPad/Controller/SRF Phas-Locked Loop/Integrator' */
  if ((LaunchPad_B.CompareToConstant != 0)) {
    LaunchPad_X.Integrator_x = 0.;
  }

  LaunchPad_B.Integrator_i1 = LaunchPad_X.Integrator_x;

  /* Trigonometric Function : 'LaunchPad/Controller/Alternating-Current Control2/3ph->RRF9/Cos' */
  LaunchPad_B.Cos = cos(LaunchPad_B.Integrator_i1);

  /* Function : 'LaunchPad/ADC Decode/Calibration/With calibration/Fcn4'
   * incorporates
   *  ADC : 'LaunchPad/ADC C'
   */
  LaunchPad_B.Fcn4 = ((HAL_getAnalogInF(0, 2)) - 1.49618999999999991) /
    0.00537390000000000003;

  /* Trigonometric Function : 'LaunchPad/Controller/Alternating-Current Control2/3ph->RRF9/Sin' */
  LaunchPad_B.Sin = sin(LaunchPad_B.Integrator_i1);

  /* Function : 'LaunchPad/ADC Decode/Calibration/With calibration/Fcn5'
   * incorporates
   *  ADC : 'LaunchPad/ADC C'
   */
  LaunchPad_B.Fcn5 = ((HAL_getAnalogInF(0, 3)) - 1.49199999999999999) /
    0.00534309999999999993;

  /* Function : 'LaunchPad/Controller/Alternating-Current Control2/3ph->RRF9/abc->d' */
  LaunchPad_B.abc_d = 0.66666666666666663 * (((LaunchPad_B.Fcn3 *
    LaunchPad_B.Cos) + (LaunchPad_B.Fcn4 * ((-0.5 * LaunchPad_B.Cos) +
    (0.866025403784438597 * LaunchPad_B.Sin)))) + (LaunchPad_B.Fcn5 * ((-0.5 *
    LaunchPad_B.Cos) - (0.866025403784438597 * LaunchPad_B.Sin))));

  /* Function : 'LaunchPad/Controller/Alternating-Current Control2/3ph->RRF9/abc->q' */
  LaunchPad_B.abc_q = 0.66666666666666663 * ((((-LaunchPad_B.Fcn3) *
    LaunchPad_B.Sin) + (LaunchPad_B.Fcn4 * ((0.5 * LaunchPad_B.Sin) +
    (0.866025403784438597 * LaunchPad_B.Cos)))) + (LaunchPad_B.Fcn5 * ((0.5 *
    LaunchPad_B.Sin) - (0.866025403784438597 * LaunchPad_B.Cos))));

  /* Signal Switch : 'LaunchPad/Controller/Alternating-Current Control2/AD 2/Switch'
   * incorporates
   *  Digital In : 'LaunchPad/SW_AD_2'
   */
  LaunchPad_B.Switch = (HAL_getDigitalIn(0)) != 0.;

  /* Signal Switch : 'LaunchPad/Controller/Alternating-Current Control2/VFF/Switch'
   * incorporates
   *  Digital In : 'LaunchPad/SW_VFF'
   */
  LaunchPad_B.Switch_1 = (HAL_getDigitalIn(1)) != 0.;

  /* ADC : 'LaunchPad/ADC B' */
  LaunchPad_B.ADCB[0] = HAL_getAnalogInF(1, 0);
  LaunchPad_B.ADCB[1] = HAL_getAnalogInF(1, 1);
  LaunchPad_B.ADCB[2] = HAL_getAnalogInF(1, 2);
  LaunchPad_B.ADCB[3] = HAL_getAnalogInF(1, 3);

  /* Function : 'LaunchPad/ADC Decode/Calibration/With calibration/Fcn' */
  LaunchPad_B.Fcn = (LaunchPad_B.ADCB[1] - 1.48804000000000003) /
    0.0703745000000000065;

  /* Function : 'LaunchPad/ADC Decode/Calibration/With calibration/Fcn1' */
  LaunchPad_B.Fcn1 = (LaunchPad_B.ADCB[2] - 1.49412999999999996) /
    0.0703745000000000065;

  /* Function : 'LaunchPad/ADC Decode/Calibration/With calibration/Fcn2' */
  LaunchPad_B.Fcn2 = (LaunchPad_B.ADCB[3] - 1.49734999999999996) /
    0.0703833999999999987;

  /* Digital In : 'LaunchPad/SW_OLPLL' */
  LaunchPad_B.SW_OLPLL = HAL_getDigitalIn(2);

  /* Digital In : 'LaunchPad/SW_ACC' */
  LaunchPad_B.SW_ACC = HAL_getDigitalIn(3);

  /* Digital In : 'LaunchPad/SW_CTRL_BW' */
  LaunchPad_B.SW_CTRL_BW = HAL_getDigitalIn(4);

  /* Digital In : 'LaunchPad/SW_OPTION_BW' */
  LaunchPad_B.SW_OPTION_BW = HAL_getDigitalIn(5);

  /* State Machine : 'LaunchPad/State Machine' */
  LaunchPad_D_double[0] = ((fabs(LaunchPad_B.Fcn3) >= 150.) || (fabs
    (LaunchPad_B.Fcn4) >= 150.) || (fabs(LaunchPad_B.Fcn5) >= 150.)) || ((fabs
    (LaunchPad_B.Fcn) >= 20.) || (fabs(LaunchPad_B.Fcn1) >= 20.) || (fabs
    (LaunchPad_B.Fcn2) >= 20.));
  LaunchPad_0_fsm_output(&LaunchPad_fsm_struct[0]);
  if (*LaunchPad_fsm_struct[0].fsm_errorStatus)
    LaunchPad_errorStatus = *LaunchPad_fsm_struct[0].fsm_errorStatus;

  /* Signal Switch : 'LaunchPad/Controller/Alternating-Current Control2/Switch'
   * incorporates
   *  Gain : 'LaunchPad/ADC Decode/Gain6'
   *  Constant : 'LaunchPad/Controller/Alternating-Current Control2/Constant2'
   */
  LaunchPad_B.Switch_2 = (LaunchPad_B.StateMachine[2] != 0.) ? (0.5*
    LaunchPad_B.ADCB[0]) : 1.;

  /* Saturation : 'LaunchPad/ADC Decode/Saturation'
   * incorporates
   *  Gain : 'LaunchPad/ADC Decode/Gain'
   *  ADC : 'LaunchPad/ADC C'
   */
  LaunchPad_B.Saturation = 6.*(HAL_getAnalogInF(0, 0));
  if (LaunchPad_B.Saturation > 11.) {
    LaunchPad_B.Saturation = 11.;
  } else if (LaunchPad_B.Saturation < 0.) {
    LaunchPad_B.Saturation = 0.;
  }

  /* Trigonometric Function : 'LaunchPad/Controller/Alternating-Current Control2/3ph->RRF7/Cos' */
  LaunchPad_B.Cos_1 = cos(LaunchPad_B.Integrator_i1);

  /* Trigonometric Function : 'LaunchPad/Controller/Alternating-Current Control2/3ph->RRF7/Sin' */
  LaunchPad_B.Sin_1 = sin(LaunchPad_B.Integrator_i1);

  /* Function : 'LaunchPad/Controller/Alternating-Current Control2/3ph->RRF7/abc->d' */
  LaunchPad_B.abc_d_1 = 0.66666666666666663 * (((LaunchPad_B.Fcn *
    LaunchPad_B.Cos_1) + (LaunchPad_B.Fcn1 * ((-0.5 * LaunchPad_B.Cos_1) +
    (0.866025403784438597 * LaunchPad_B.Sin_1)))) + (LaunchPad_B.Fcn2 * ((-0.5 *
    LaunchPad_B.Cos_1) - (0.866025403784438597 * LaunchPad_B.Sin_1))));

  /* Signal Switch : 'LaunchPad/Controller/Alternating-Current Control2/VDC_derivative/Switch'
   * incorporates
   *  Digital In : 'LaunchPad/SW_AD_3'
   */
  LaunchPad_B.Switch_3 = (HAL_getDigitalIn(6)) != 0.;

  /* Integrator : 'LaunchPad/Controller/Alternating-Current Control2/dd-axis\nVirtual Damping Control/Integrator' */
  LaunchPad_B.Integrator_1 = LaunchPad_X.Integrator_1_x;

  /* Digital In : 'LaunchPad/SW_VDC' */
  LaunchPad_B.SW_VDC = HAL_getDigitalIn(7);

  /* Sum : 'LaunchPad/Controller/Alternating-Current Control2/Sum'
   * incorporates
   *  Sum : 'LaunchPad/Controller/Alternating-Current Control2/Sum12'
   *  Signal Switch : 'LaunchPad/Controller/Alternating-Current Control2/VDC_derivative/Switch'
   *  Transfer Function : 'LaunchPad/Controller/Alternating-Current Control2/VDC_derivative/HPF'
   *  Constant : 'LaunchPad/Controller/Alternating-Current Control2/VDC_derivative/Constant'
   *  Signal Switch : 'LaunchPad/Controller/Alternating-Current Control2/dd-axis\nVirtual Damping Control/Switch'
   *  Sum : 'LaunchPad/Controller/Alternating-Current Control2/dd-axis\nVirtual Damping Control/Sum'
   *  Gain : 'LaunchPad/Controller/Alternating-Current Control2/dd-axis\nVirtual Damping Control/Gain'
   *  Constant : 'LaunchPad/Controller/Alternating-Current Control2/dd-axis\nVirtual Damping Control/Constant'
   */
  LaunchPad_B.Sum = LaunchPad_B.Saturation - LaunchPad_B.abc_d_1 -
    ((LaunchPad_B.Switch_3 ? (4398.22971502570999*(-1.22598632207228707e-05*
        LaunchPad_B.abc_d)-19344424.6261351369*LaunchPad_X.HPF_1[0]) : 0.) +
     ((LaunchPad_B.SW_VDC != 0.) ? ((0.*LaunchPad_B.abc_d) +
       LaunchPad_B.Integrator_1) : 0.));

  /* Integrator : 'LaunchPad/Controller/Alternating-Current Control2/d-axis\nPI Regulator/Integrator' */
  if (((!LaunchPad_X.Integrator_2_prevReset && LaunchPad_B.StateMachine[1]) ||
       (LaunchPad_X.Integrator_2_prevReset && !LaunchPad_B.StateMachine[1]))) {
    LaunchPad_X.Integrator_2_x = 0.;
  }

  if (LaunchPad_X.Integrator_2_x > 200.) {
    LaunchPad_X.Integrator_2_x = 200.;
  } else if (LaunchPad_X.Integrator_2_x < -200.) {
    LaunchPad_X.Integrator_2_x = -200.;
  }

  LaunchPad_B.Integrator_2 = LaunchPad_X.Integrator_2_x;

  /* Function : 'LaunchPad/Controller/Alternating-Current Control2/3ph->RRF7/abc->q' */
  LaunchPad_B.abc_q_1 = 0.66666666666666663 * ((((-LaunchPad_B.Fcn) *
    LaunchPad_B.Sin_1) + (LaunchPad_B.Fcn1 * ((0.5 * LaunchPad_B.Sin_1) +
    (0.866025403784438597 * LaunchPad_B.Cos_1)))) + (LaunchPad_B.Fcn2 * ((0.5 *
    LaunchPad_B.Sin_1) - (0.866025403784438597 * LaunchPad_B.Cos_1))));

  /* Sum : 'LaunchPad/Controller/Alternating-Current Control2/Sum9'
   * incorporates
   *  Signal Switch : 'LaunchPad/Controller/Alternating-Current Control2/AD 2/Switch'
   *  Transfer Function : 'LaunchPad/Controller/Alternating-Current Control2/AD 2/HPF'
   *  Constant : 'LaunchPad/Controller/Alternating-Current Control2/AD 2/Constant'
   *  Sum : 'LaunchPad/Controller/Alternating-Current Control2/Sum7'
   *  Signal Switch : 'LaunchPad/Controller/Alternating-Current Control2/VFF/Switch'
   *  Transfer Function : 'LaunchPad/Controller/Alternating-Current Control2/VFF/LPF'
   *  Constant : 'LaunchPad/Controller/Alternating-Current Control2/VFF/Constant'
   *  Sum : 'LaunchPad/Controller/Alternating-Current Control2/d-axis\nPI Regulator/Sum'
   *  Product : 'LaunchPad/Controller/Alternating-Current Control2/d-axis\nPI Regulator/Product'
   *  Gain : 'LaunchPad/Controller/Alternating-Current Control2/d-axis\nPI Regulator/Gain'
   *  Gain : 'LaunchPad/Controller/Alternating-Current Control2/Gain'
   */
  LaunchPad_B.Sum9 = (LaunchPad_B.Switch ? (4398.22971502570999*
    (0.000192577481141193384*LaunchPad_B.abc_d)-19344424.6261351369*
    LaunchPad_X.HPF[0]) : 0.) + ((LaunchPad_B.Switch_1 ? (3141.59265358979292*
    LaunchPad_X.LPF[0]) : 0.) + ((LaunchPad_B.Switch_2 * (15.5999999999999996*
    LaunchPad_B.Sum)) + LaunchPad_B.Integrator_2) - (0.785398163397448279*
    LaunchPad_B.abc_q_1));

  /* Trigonometric Function : 'LaunchPad/Controller/Alternating-Current Control2/RRF->3ph/Cos' */
  LaunchPad_B.Cos_2 = cos(LaunchPad_B.Integrator_i1);

  /* Integrator : 'LaunchPad/Controller/Alternating-Current Control2/qq-axis\nVirtual Damping Control/Integrator' */
  LaunchPad_B.Integrator_3 = LaunchPad_X.Integrator_3_x;

  /* Sum : 'LaunchPad/Controller/Alternating-Current Control2/Sum2'
   * incorporates
   *  Constant : 'LaunchPad/Controller/Alternating-Current Control2/Constant'
   *  Sum : 'LaunchPad/Controller/Alternating-Current Control2/Sum11'
   *  Signal Switch : 'LaunchPad/Controller/Alternating-Current Control2/VDC_derivative/Switch'
   *  Transfer Function : 'LaunchPad/Controller/Alternating-Current Control2/VDC_derivative/HPF'
   *  Constant : 'LaunchPad/Controller/Alternating-Current Control2/VDC_derivative/Constant'
   *  Signal Switch : 'LaunchPad/Controller/Alternating-Current Control2/qq-axis\nVirtual Damping Control/Switch'
   *  Sum : 'LaunchPad/Controller/Alternating-Current Control2/qq-axis\nVirtual Damping Control/Sum'
   *  Gain : 'LaunchPad/Controller/Alternating-Current Control2/qq-axis\nVirtual Damping Control/Gain'
   *  Constant : 'LaunchPad/Controller/Alternating-Current Control2/qq-axis\nVirtual Damping Control/Constant'
   */
  LaunchPad_B.Sum2 = 0. - LaunchPad_B.abc_q_1 - ((LaunchPad_B.Switch_3 ?
    (4398.22971502570999*(-1.22598632207228707e-05*LaunchPad_B.abc_q)-
     19344424.6261351369*LaunchPad_X.HPF_1[1]) : 0.) + ((LaunchPad_B.SW_VDC !=
    0.) ? ((0.0400000000000000008*LaunchPad_B.abc_q) + LaunchPad_B.Integrator_3)
    : 0.));

  /* Integrator : 'LaunchPad/Controller/Alternating-Current Control2/q-axis\nPI Regulator/Integrator' */
  if (((!LaunchPad_X.Integrator_4_prevReset && LaunchPad_B.StateMachine[1]) ||
       (LaunchPad_X.Integrator_4_prevReset && !LaunchPad_B.StateMachine[1]))) {
    LaunchPad_X.Integrator_4_x = 0.;
  }

  if (LaunchPad_X.Integrator_4_x > 200.) {
    LaunchPad_X.Integrator_4_x = 200.;
  } else if (LaunchPad_X.Integrator_4_x < -200.) {
    LaunchPad_X.Integrator_4_x = -200.;
  }

  LaunchPad_B.Integrator_4 = LaunchPad_X.Integrator_4_x;

  /* Sum : 'LaunchPad/Controller/Alternating-Current Control2/Sum10'
   * incorporates
   *  Sum : 'LaunchPad/Controller/Alternating-Current Control2/Sum8'
   *  Gain : 'LaunchPad/Controller/Alternating-Current Control2/Gain2'
   *  Sum : 'LaunchPad/Controller/Alternating-Current Control2/q-axis\nPI Regulator/Sum'
   *  Product : 'LaunchPad/Controller/Alternating-Current Control2/q-axis\nPI Regulator/Product'
   *  Gain : 'LaunchPad/Controller/Alternating-Current Control2/q-axis\nPI Regulator/Gain'
   *  Signal Switch : 'LaunchPad/Controller/Alternating-Current Control2/VFF/Switch'
   *  Transfer Function : 'LaunchPad/Controller/Alternating-Current Control2/VFF/LPF'
   *  Constant : 'LaunchPad/Controller/Alternating-Current Control2/VFF/Constant'
   *  Signal Switch : 'LaunchPad/Controller/Alternating-Current Control2/AD 2/Switch'
   *  Transfer Function : 'LaunchPad/Controller/Alternating-Current Control2/AD 2/HPF'
   *  Constant : 'LaunchPad/Controller/Alternating-Current Control2/AD 2/Constant'
   */
  LaunchPad_B.Sum10 = ((0.785398163397448279*LaunchPad_B.abc_d_1) +
                       ((LaunchPad_B.Switch_2 * (15.5999999999999996*
    LaunchPad_B.Sum2)) + LaunchPad_B.Integrator_4) + (LaunchPad_B.Switch_1 ?
    (3141.59265358979292*LaunchPad_X.LPF[1]) : 0.)) + (LaunchPad_B.Switch ?
    (4398.22971502570999*(0.000192577481141193384*LaunchPad_B.abc_q)-
     19344424.6261351369*LaunchPad_X.HPF[1]) : 0.);

  /* Trigonometric Function : 'LaunchPad/Controller/Alternating-Current Control2/RRF->3ph/Sin' */
  LaunchPad_B.Sin_2 = sin(LaunchPad_B.Integrator_i1);

  /* Function : 'LaunchPad/Controller/Alternating-Current Control2/RRF->3ph/dq->a' */
  LaunchPad_B.dq_a = (LaunchPad_B.Sum9 * LaunchPad_B.Cos_2) - (LaunchPad_B.Sum10
    * LaunchPad_B.Sin_2);

  /* Function : 'LaunchPad/Controller/Alternating-Current Control2/RRF->3ph/dq->b' */
  LaunchPad_B.dq_b = (LaunchPad_B.Sum9 * ((-0.5 * LaunchPad_B.Cos_2) +
    (0.866025403784438597 * LaunchPad_B.Sin_2))) + (LaunchPad_B.Sum10 * ((0.5 *
    LaunchPad_B.Sin_2) + (0.866025403784438597 * LaunchPad_B.Cos_2)));

  /* Gain : 'LaunchPad/Controller/Alternating-Current Control2/Gain3'
   * incorporates
   *  Sum : 'LaunchPad/Controller/Alternating-Current Control2/RRF->3ph/Sum1'
   */
  LaunchPad_B.Gain3[0] = 0.0111111111111111115*LaunchPad_B.dq_a;
  LaunchPad_B.Gain3[1] = 0.0111111111111111115*LaunchPad_B.dq_b;
  LaunchPad_B.Gain3[2] = 0.0111111111111111115*(-LaunchPad_B.dq_b -
    LaunchPad_B.dq_a);
  if (LaunchPad_subTaskHit[0]) {
    /* Delay : 'LaunchPad/Delay' */
    LaunchPad_B.Delay[0] = LaunchPad_X.Delay[0];
    LaunchPad_B.Delay[1] = LaunchPad_X.Delay[1];
    LaunchPad_B.Delay[2] = LaunchPad_X.Delay[2];
  }

  /* Saturation : 'LaunchPad/Controller/Alternating-Current Control2/Saturation' */
  LaunchPad_B.Saturation_1[0] = LaunchPad_B.Gain3[0];
  if (LaunchPad_B.Saturation_1[0] > 1.) {
    LaunchPad_B.Saturation_1[0] = 1.;
  } else if (LaunchPad_B.Saturation_1[0] < -1.) {
    LaunchPad_B.Saturation_1[0] = -1.;
  }

  LaunchPad_B.Saturation_1[1] = LaunchPad_B.Gain3[1];
  if (LaunchPad_B.Saturation_1[1] > 1.) {
    LaunchPad_B.Saturation_1[1] = 1.;
  } else if (LaunchPad_B.Saturation_1[1] < -1.) {
    LaunchPad_B.Saturation_1[1] = -1.;
  }

  LaunchPad_B.Saturation_1[2] = LaunchPad_B.Gain3[2];
  if (LaunchPad_B.Saturation_1[2] > 1.) {
    LaunchPad_B.Saturation_1[2] = 1.;
  } else if (LaunchPad_B.Saturation_1[2] < -1.) {
    LaunchPad_B.Saturation_1[2] = -1.;
  }

  /* Trigonometric Function : 'LaunchPad/Controller/OL/RRF->3ph/Cos' */
  LaunchPad_B.Cos_3 = cos(LaunchPad_B.Integrator_i1);

  /* Trigonometric Function : 'LaunchPad/Controller/OL/RRF->3ph/Sin' */
  LaunchPad_B.Sin_3 = sin(LaunchPad_B.Integrator_i1);

  /* Function : 'LaunchPad/Controller/OL/RRF->3ph/dq->a'
   * incorporates
   *  Constant : 'LaunchPad/Controller/OL/vc_d_ref'
   *  Constant : 'LaunchPad/Controller/OL/vc_q_ref'
   */
  LaunchPad_B.dq_a_1 = (0.800000000000000044 * LaunchPad_B.Cos_3) - (0. *
    LaunchPad_B.Sin_3);

  /* Function : 'LaunchPad/Controller/OL/RRF->3ph/dq->b'
   * incorporates
   *  Constant : 'LaunchPad/Controller/OL/vc_d_ref'
   *  Constant : 'LaunchPad/Controller/OL/vc_q_ref'
   */
  LaunchPad_B.dq_b_1 = (0.800000000000000044 * ((-0.5 * LaunchPad_B.Cos_3) +
    (0.866025403784438597 * LaunchPad_B.Sin_3))) + (0. * ((0.5 *
    LaunchPad_B.Sin_3) + (0.866025403784438597 * LaunchPad_B.Cos_3)));

  /* Signal Switch : 'LaunchPad/Controller/output selector/Switch' */
  LaunchPad_B.Switch_4 = LaunchPad_B.StateMachine[1] != 0.;

  /* Signal Switch : 'LaunchPad/Controller/output selector/Switch1' */
  LaunchPad_B.Switch1 = LaunchPad_B.StateMachine[0] != 0.;

  /* Signal Switch : 'LaunchPad/Controller/output selector/Switch1'
   * incorporates
   *  Signal Switch : 'LaunchPad/Controller/output selector/Switch'
   *  Sum : 'LaunchPad/Controller/Alternating-Current Control2/2L pwm/Sum'
   *  Gain : 'LaunchPad/Controller/Alternating-Current Control2/2L pwm/Gain'
   *  Constant : 'LaunchPad/Controller/Alternating-Current Control2/2L pwm/Constant'
   *  Sum : 'LaunchPad/Controller/OL/2L pwm/Sum'
   *  Gain : 'LaunchPad/Controller/OL/2L pwm/Gain'
   *  Sum : 'LaunchPad/Controller/OL/RRF->3ph/Sum1'
   *  Constant : 'LaunchPad/Controller/OL/2L pwm/Constant'
   *  Constant : 'LaunchPad/Controller/output selector/Constant2'
   */
  LaunchPad_B.Switch1_i1[0] = LaunchPad_B.Switch1 ? (LaunchPad_B.Switch_4 ?
    ((0.5*LaunchPad_B.Saturation_1[0]) + 0.5) : ((0.5*LaunchPad_B.dq_a_1) + 0.5))
    : 0.;
  LaunchPad_B.Switch1_i1[1] = LaunchPad_B.Switch1 ? (LaunchPad_B.Switch_4 ?
    ((0.5*LaunchPad_B.Saturation_1[1]) + 0.5) : ((0.5*LaunchPad_B.dq_b_1) + 0.5))
    : 0.;
  LaunchPad_B.Switch1_i1[2] = LaunchPad_B.Switch1 ? (LaunchPad_B.Switch_4 ?
    ((0.5*LaunchPad_B.Saturation_1[2]) + 0.5) : ((0.5*(-LaunchPad_B.dq_b_1 -
    LaunchPad_B.dq_a_1)) + 0.5)) : 0.;

  /* Signal Switch : 'LaunchPad/Switch'
   * incorporates
   *  Digital In : 'LaunchPad/SW_DELAY'
   */
  LaunchPad_B.Switch_5 = (HAL_getDigitalIn(8)) != 0.;

  /* PWM  : 'LaunchPad/PWM' */
  HAL_setPwmDuty(0, LaunchPad_B.Switch_5 ? LaunchPad_B.Delay[0] :
                 LaunchPad_B.Switch1_i1[0]);
  HAL_setPwmDuty(1, LaunchPad_B.Switch_5 ? LaunchPad_B.Delay[1] :
                 LaunchPad_B.Switch1_i1[1]);
  HAL_setPwmDuty(2, LaunchPad_B.Switch_5 ? LaunchPad_B.Delay[2] :
                 LaunchPad_B.Switch1_i1[2]);

  /* Digital Out : 'LaunchPad/Contactor' */
  HAL_setDigitalOut(0, LaunchPad_B.StateMachine[4]);

  /* Digital Out : 'LaunchPad/State_Units0' */
  HAL_setDigitalOut(1, LaunchPad_B.StateMachine[5]);

  /* Digital Out : 'LaunchPad/State_Units1' */
  HAL_setDigitalOut(2, LaunchPad_B.StateMachine[6]);

  /* Digital Out : 'LaunchPad/State_Units2' */
  HAL_setDigitalOut(3, LaunchPad_B.StateMachine[7]);

  /* Digital Out : 'LaunchPad/State_Units3' */
  HAL_setDigitalOut(4, LaunchPad_B.StateMachine[8]);

  /* DAC : 'LaunchPad/DAC_Id' */
  HAL_setDacOutF(0, LaunchPad_B.abc_d_1);

  /* DAC : 'LaunchPad/DAC_Iq' */
  HAL_setDacOutF(1, LaunchPad_B.abc_q_1);

  /* Signal Switch : 'LaunchPad/Controller/SRF Phas-Locked Loop/Switch1'
   * incorporates
   *  Gain : 'LaunchPad/ADC Decode/Gain2'
   *  Constant : 'LaunchPad/Controller/SRF Phas-Locked Loop/Constant2'
   */
  LaunchPad_B.Switch1_1 = (LaunchPad_B.StateMachine[3] != 0.) ? (5.*
    LaunchPad_B.ADCB[0]) : 1.;

  /* Trigonometric Function : 'LaunchPad/Controller/SRF Phas-Locked Loop/3ph->RRF/Sin' */
  LaunchPad_B.Sin_4 = sin(LaunchPad_B.Integrator_i1);

  /* Trigonometric Function : 'LaunchPad/Controller/SRF Phas-Locked Loop/3ph->RRF/Cos' */
  LaunchPad_B.Cos_4 = cos(LaunchPad_B.Integrator_i1);

  /* Function : 'LaunchPad/Controller/SRF Phas-Locked Loop/3ph->RRF/abc->q' */
  LaunchPad_B.abc_q_2 = 0.66666666666666663 * ((((-LaunchPad_B.Fcn3) *
    LaunchPad_B.Sin_4) + (LaunchPad_B.Fcn4 * ((0.5 * LaunchPad_B.Sin_4) +
    (0.866025403784438597 * LaunchPad_B.Cos_4)))) + (LaunchPad_B.Fcn5 * ((0.5 *
    LaunchPad_B.Sin_4) - (0.866025403784438597 * LaunchPad_B.Cos_4))));

  /* Integrator : 'LaunchPad/Controller/SRF Phas-Locked Loop/PLL\nPI Regulator/Integrator' */
  if (((!LaunchPad_X.Integrator_5_prevReset && LaunchPad_B.StateMachine[0]) ||
       (LaunchPad_X.Integrator_5_prevReset && !LaunchPad_B.StateMachine[0]))) {
    LaunchPad_X.Integrator_5_x = 0.;
  }

  LaunchPad_B.Integrator_5 = LaunchPad_X.Integrator_5_x;

  /* Sum : 'LaunchPad/Controller/SRF Phas-Locked Loop/Sum3'
   * incorporates
   *  Constant : 'LaunchPad/Controller/SRF Phas-Locked Loop/Constant1'
   *  Sum : 'LaunchPad/Controller/SRF Phas-Locked Loop/PLL\nPI Regulator/Sum1'
   *  Product : 'LaunchPad/Controller/SRF Phas-Locked Loop/PLL\nPI Regulator/Product'
   *  Gain : 'LaunchPad/Controller/SRF Phas-Locked Loop/PLL\nPI Regulator/Gain5'
   */
  LaunchPad_B.Sum3 = 314.159265358979326 + ((LaunchPad_B.Switch1_1 *
    (2.29999999999999982*LaunchPad_B.abc_q_2)) + LaunchPad_B.Integrator_5);

  /* Product : 'LaunchPad/Controller/SRF Phas-Locked Loop/PLL\nPI Regulator/Product2'
   * incorporates
   *  Math Function : 'LaunchPad/Controller/SRF Phas-Locked Loop/PLL\nPI Regulator/Math'
   *  Gain : 'LaunchPad/Controller/SRF Phas-Locked Loop/PLL\nPI Regulator/Gain4'
   */
  LaunchPad_B.Product2 = (LaunchPad_B.Switch1_1 * LaunchPad_B.Switch1_1) * (251.*
    LaunchPad_B.abc_q_2);

  /* Gain : 'LaunchPad/Controller/Alternating-Current Control2/dd-axis\nVirtual Damping Control/Gain2' */
  LaunchPad_B.Gain2 = 0.*LaunchPad_B.abc_d;

  /* Gain : 'LaunchPad/Controller/Alternating-Current Control2/d-axis\nPI Regulator/Gain2' */
  LaunchPad_B.Gain2_1 = 11014.*LaunchPad_B.Sum;

  /* Gain : 'LaunchPad/Controller/Alternating-Current Control2/qq-axis\nVirtual Damping Control/Gain2' */
  LaunchPad_B.Gain2_2 = 40.*LaunchPad_B.abc_q;

  /* Gain : 'LaunchPad/Controller/Alternating-Current Control2/q-axis\nPI Regulator/Gain2' */
  LaunchPad_B.Gain2_3 = 11014.*LaunchPad_B.Sum2;
  if (LaunchPad_errorStatus) {
    return;
  }

  /* Update for Integrator : 'LaunchPad/Controller/Alternating-Current Control2/d-axis\nPI Regulator/Integrator' */
  LaunchPad_X.Integrator_2_prevReset = !!(LaunchPad_B.StateMachine[1]);

  /* Update for Integrator : 'LaunchPad/Controller/Alternating-Current Control2/q-axis\nPI Regulator/Integrator' */
  LaunchPad_X.Integrator_4_prevReset = !!(LaunchPad_B.StateMachine[1]);
  if (LaunchPad_subTaskHit[0]) {
    /* Update for Delay : 'LaunchPad/Delay' */
    LaunchPad_X.Delay[0] = LaunchPad_B.Switch1_i1[0];
    LaunchPad_X.Delay[1] = LaunchPad_B.Switch1_i1[1];
    LaunchPad_X.Delay[2] = LaunchPad_B.Switch1_i1[2];
  }

  /* Update for Integrator : 'LaunchPad/Controller/SRF Phas-Locked Loop/PLL\nPI Regulator/Integrator' */
  LaunchPad_X.Integrator_5_prevReset = !!(LaunchPad_B.StateMachine[0]);

  /* Increment sub-task tick counters */
  {
    size_t i;
    for (i = 0; i < 1; ++i) {
      LaunchPad_subTaskTick[i]++;
      if (LaunchPad_subTaskTick[i] >= LaunchPad_subTaskPeriod[i]) {
        LaunchPad_subTaskTick[i] = 0;
      }
    }
  }

  /* Derivatives for Integrator : 'LaunchPad/Controller/SRF Phas-Locked Loop/Integrator' */
  if (LaunchPad_B.CompareToConstant != 0) {
    LaunchPad_deriv[0] = 0;
  } else {
    LaunchPad_deriv[0] = LaunchPad_B.Sum3;
  }

  /* Derivatives for Transfer Function : 'LaunchPad/Controller/Alternating-Current Control2/AD 2/HPF'
   * incorporates
   *  Gain : 'LaunchPad/Controller/Alternating-Current Control2/AD 2/Gain3'
   */
  LaunchPad_deriv[10] = 0.000192577481141193384*LaunchPad_B.abc_d-
    4398.22971502570999*LaunchPad_X.HPF[0];
  LaunchPad_deriv[11] = 0.000192577481141193384*LaunchPad_B.abc_q-
    4398.22971502570999*LaunchPad_X.HPF[1];

  /* Derivatives for Transfer Function : 'LaunchPad/Controller/Alternating-Current Control2/VFF/LPF' */
  LaunchPad_deriv[2] = LaunchPad_B.abc_d-3141.59265358979292*LaunchPad_X.LPF[0];
  LaunchPad_deriv[3] = LaunchPad_B.abc_q-3141.59265358979292*LaunchPad_X.LPF[1];

  /* Derivatives for Transfer Function : 'LaunchPad/Controller/Alternating-Current Control2/VDC_derivative/HPF'
   * incorporates
   *  Gain : 'LaunchPad/Controller/Alternating-Current Control2/VDC_derivative/Gain3'
   */
  LaunchPad_deriv[8] = -1.22598632207228707e-05*LaunchPad_B.abc_d-
    4398.22971502570999*LaunchPad_X.HPF_1[0];
  LaunchPad_deriv[9] = -1.22598632207228707e-05*LaunchPad_B.abc_q-
    4398.22971502570999*LaunchPad_X.HPF_1[1];

  /* Derivatives for Integrator : 'LaunchPad/Controller/Alternating-Current Control2/dd-axis\nVirtual Damping Control/Integrator' */
  LaunchPad_deriv[4] = LaunchPad_B.Gain2;

  /* Derivatives for Integrator : 'LaunchPad/Controller/Alternating-Current Control2/d-axis\nPI Regulator/Integrator' */
  if ((LaunchPad_X.Integrator_2_x >= 200. && LaunchPad_B.Gain2_1 > 0) ||
      (LaunchPad_X.Integrator_2_x <= -200. && LaunchPad_B.Gain2_1 < 0)) {
    LaunchPad_deriv[6] = 0;
  } else {
    LaunchPad_deriv[6] = LaunchPad_B.Gain2_1;
  }

  /* Derivatives for Integrator : 'LaunchPad/Controller/Alternating-Current Control2/qq-axis\nVirtual Damping Control/Integrator' */
  LaunchPad_deriv[5] = LaunchPad_B.Gain2_2;

  /* Derivatives for Integrator : 'LaunchPad/Controller/Alternating-Current Control2/q-axis\nPI Regulator/Integrator' */
  if ((LaunchPad_X.Integrator_4_x >= 200. && LaunchPad_B.Gain2_3 > 0) ||
      (LaunchPad_X.Integrator_4_x <= -200. && LaunchPad_B.Gain2_3 < 0)) {
    LaunchPad_deriv[7] = 0;
  } else {
    LaunchPad_deriv[7] = LaunchPad_B.Gain2_3;
  }

  /* Derivatives for Integrator : 'LaunchPad/Controller/SRF Phas-Locked Loop/PLL\nPI Regulator/Integrator' */
  LaunchPad_deriv[1] = LaunchPad_B.Product2;

  /* Update continuous states */
  LaunchPad_X.Integrator_x += 5.00000000000000024e-05*LaunchPad_deriv[0];
  LaunchPad_X.HPF[0] += 5.00000000000000024e-05*LaunchPad_deriv[10];
  LaunchPad_X.HPF[1] += 5.00000000000000024e-05*LaunchPad_deriv[11];
  LaunchPad_X.LPF[0] += 5.00000000000000024e-05*LaunchPad_deriv[2];
  LaunchPad_X.LPF[1] += 5.00000000000000024e-05*LaunchPad_deriv[3];
  LaunchPad_X.HPF_1[0] += 5.00000000000000024e-05*LaunchPad_deriv[8];
  LaunchPad_X.HPF_1[1] += 5.00000000000000024e-05*LaunchPad_deriv[9];
  LaunchPad_X.Integrator_1_x += 5.00000000000000024e-05*LaunchPad_deriv[4];
  LaunchPad_X.Integrator_2_x += 5.00000000000000024e-05*LaunchPad_deriv[6];
  LaunchPad_X.Integrator_3_x += 5.00000000000000024e-05*LaunchPad_deriv[5];
  LaunchPad_X.Integrator_4_x += 5.00000000000000024e-05*LaunchPad_deriv[7];
  LaunchPad_X.Integrator_5_x += 5.00000000000000024e-05*LaunchPad_deriv[1];
}

void LaunchPad_terminate()
{
}
