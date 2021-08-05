/*
 * Header file for: SM_Coder_FSM_PLL_ACC_DVC/Circuit/LaunchPad
 * Generated with : PLECS 4.4.5
 *                  TI2837xS 1.2
 * Generated on   : 5 Aug 2021 18:07:03
 */

#ifndef PLECS_HEADER_LaunchPad_h_
#define PLECS_HEADER_LaunchPad_h_
#include <stdbool.h>
#include <stdint.h>

/* Target declarations */
typedef int_fast8_t int8_t;
typedef uint_fast8_t uint8_t;
extern void LaunchPad_background(void);

/* Model floating point type */
typedef double LaunchPad_FloatType;

/* Model checksum */
extern const char * const LaunchPad_checksum;

/* Model error status */
extern const char * LaunchPad_errorStatus;

/* Model sample time */
extern const double LaunchPad_sampleTime;

/*
 * Model states */
typedef struct {
  double LPF[2];                       /* /LaunchPad/Controller/Alternating-Current Control1/VFF/LPF */
  double StateMachine[4];              /* /LaunchPad/State Machine */
  double Integrator_x;                 /* /LaunchPad/Controller/Direct-Voltage Control/DVC PI Regulator/Integrator */
  bool Integrator_prevReset;           /* /LaunchPad/Controller/Direct-Voltage Control/DVC PI Regulator/Integrator */
  double Integrator_1_x;               /* /LaunchPad/Controller/Phase-Locked Loop/Integrator */
  double Integrator_2_x;               /* /LaunchPad/Controller/Alternating-Current Control1/d-axis PI Regulator/Integrator */
  bool Integrator_2_prevReset;         /* /LaunchPad/Controller/Alternating-Current Control1/d-axis PI Regulator/Integrator */
  double Integrator_3_x;               /* /LaunchPad/Controller/Alternating-Current Control1/q-axis PI Regulator/Integrator */
  bool Integrator_3_prevReset;         /* /LaunchPad/Controller/Alternating-Current Control1/q-axis PI Regulator/Integrator */
  double Integrator_4_x;               /* /LaunchPad/Controller/Phase-Locked Loop/PLL PI Regulator/Integrator */
  bool Integrator_4_prevReset;         /* /LaunchPad/Controller/Phase-Locked Loop/PLL PI Regulator/Integrator */
} LaunchPad_ModelStates;

extern LaunchPad_ModelStates LaunchPad_X;

/* Block outputs */
typedef struct {
  double Saturation;                   /* /LaunchPad/ADC Decode/Saturation */
  double StateMachine[8];              /* /LaunchPad/State Machine */
  double Saturation1;                  /* /LaunchPad/Controller/Modulator/Saturation1 */
  double Saturation_1[3];              /* /LaunchPad/Controller/Modulator/Saturation */
  double SW_PLL;                       /* /LaunchPad/SW_PLL */
  double SW_DVC;                       /* /LaunchPad/SW_DVC */
  double Fcn6;                         /* /LaunchPad/ADC Decode/Calibration/With calibration/Fcn6 */
  double Sum1;                         /* /LaunchPad/Controller/Direct-Voltage Control/Sum1 */
  double Fcn3;                         /* /LaunchPad/ADC Decode/Calibration/With calibration/Fcn3 */
  double Fcn4;                         /* /LaunchPad/ADC Decode/Calibration/With calibration/Fcn4 */
  double Fcn5;                         /* /LaunchPad/ADC Decode/Calibration/With calibration/Fcn5 */
  double Fcn;                          /* /LaunchPad/ADC Decode/Calibration/With calibration/Fcn */
  double Fcn1;                         /* /LaunchPad/ADC Decode/Calibration/With calibration/Fcn1 */
  double Fcn2;                         /* /LaunchPad/ADC Decode/Calibration/With calibration/Fcn2 */
  double Integrator;                   /* /LaunchPad/Controller/Direct-Voltage Control/DVC PI Regulator/Integrator */
  double Integrator_1;                 /* /LaunchPad/Controller/Phase-Locked Loop/Integrator */
  bool CompareToConstant;              /* /LaunchPad/Controller/Phase-Locked Loop/Compare to Constant */
  double Integrator_1_i1;              /* /LaunchPad/Controller/Phase-Locked Loop/Integrator */
  double Cos;                          /* /LaunchPad/Controller/Alternating-Current Control1/3ph->RRF7/Cos */
  double Sin;                          /* /LaunchPad/Controller/Alternating-Current Control1/3ph->RRF7/Sin */
  double abc_d;                        /* /LaunchPad/Controller/Alternating-Current Control1/3ph->RRF7/abc->d */
  double Sum;                          /* /LaunchPad/Controller/Alternating-Current Control1/Sum */
  double Integrator_2;                 /* /LaunchPad/Controller/Alternating-Current Control1/d-axis PI Regulator/Integrator */
  double abc_q;                        /* /LaunchPad/Controller/Alternating-Current Control1/3ph->RRF7/abc->q */
  double Sum7;                         /* /LaunchPad/Controller/Alternating-Current Control1/Sum7 */
  double Cos_1;                        /* /LaunchPad/Controller/Alternating-Current Control1/RRF->SRF/Cos */
  double Sum2;                         /* /LaunchPad/Controller/Alternating-Current Control1/Sum2 */
  double Integrator_3;                 /* /LaunchPad/Controller/Alternating-Current Control1/q-axis PI Regulator/Integrator */
  double Sum8;                         /* /LaunchPad/Controller/Alternating-Current Control1/Sum8 */
  double Sin_1;                        /* /LaunchPad/Controller/Alternating-Current Control1/RRF->SRF/Sin */
  double dq_alpha;                     /* /LaunchPad/Controller/Alternating-Current Control1/RRF->SRF/dq->alpha */
  double dq_beta;                      /* /LaunchPad/Controller/Alternating-Current Control1/RRF->SRF/dq->beta */
  double Cos_2;                        /* /LaunchPad/Controller/Alternating-Current Control1/3ph->RRF9/Cos */
  double Sin_2;                        /* /LaunchPad/Controller/Alternating-Current Control1/3ph->RRF9/Sin */
  double Gain2;                        /* /LaunchPad/Controller/Direct-Voltage Control/DVC PI Regulator/Gain2 */
  double Sin_3;                        /* /LaunchPad/Controller/Phase-Locked Loop/3ph->RRF/Sin */
  double Cos_3;                        /* /LaunchPad/Controller/Phase-Locked Loop/3ph->RRF/Cos */
  double abc_q_1;                      /* /LaunchPad/Controller/Phase-Locked Loop/3ph->RRF/abc->q */
  double Integrator_4;                 /* /LaunchPad/Controller/Phase-Locked Loop/PLL PI Regulator/Integrator */
  double Sum3;                         /* /LaunchPad/Controller/Phase-Locked Loop/Sum3 */
  double Gain2_1;                      /* /LaunchPad/Controller/Phase-Locked Loop/PLL PI Regulator/Gain2 */
  double Gain2_2;                      /* /LaunchPad/Controller/Alternating-Current Control1/d-axis PI Regulator/Gain2 */
  double Gain2_3;                      /* /LaunchPad/Controller/Alternating-Current Control1/q-axis PI Regulator/Gain2 */
} LaunchPad_BlockOutputs;

extern LaunchPad_BlockOutputs LaunchPad_B;

#if defined(EXTERNAL_MODE) && EXTERNAL_MODE

/* External mode signals */
#define LaunchPad_NumExtModeSignals    0

extern const double * const LaunchPad_ExtModeSignals[];

/* Tunable parameters */
#define LaunchPad_NumTunableParameters 0
#endif                                 /* defined(EXTERNAL_MODE) */

/* Entry point functions */
void LaunchPad_initialize(double time);
void LaunchPad_step(void);
void LaunchPad_terminate(void);

#endif                                 /* PLECS_HEADER_LaunchPad_h_ */
