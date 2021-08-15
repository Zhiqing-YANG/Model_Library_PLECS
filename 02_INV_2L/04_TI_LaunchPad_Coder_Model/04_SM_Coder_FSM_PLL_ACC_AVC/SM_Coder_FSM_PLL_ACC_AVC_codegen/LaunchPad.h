/*
 * Header file for: SM_Coder_FSM_PLL_ACC_AVC/ Three-Phase 2L Grid-Tied  Inverter/LaunchPad
 * Generated with : PLECS 4.4.5
 *                  TI2837xS 1.2
 * Generated on   : 14 Aug 2021 11:21:10
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
  double Integrator_x;                 /* /LaunchPad/Controller/Alternating-Voltage Control/d-axis PI Regulator/Integrator */
  bool Integrator_prevReset;           /* /LaunchPad/Controller/Alternating-Voltage Control/d-axis PI Regulator/Integrator */
  double Integrator_1_x;               /* /LaunchPad/Controller/Alternating-Voltage Control/q-axis PI Regulator/Integrator */
  bool Integrator_1_prevReset;         /* /LaunchPad/Controller/Alternating-Voltage Control/q-axis PI Regulator/Integrator */
  double Delay[3];                     /* /LaunchPad/Controller/Delay */
  double LPF[2];                       /* /LaunchPad/Controller/Alternating-Current Control/PI/VFF/LPF */
  double Integrator_2_x;               /* /LaunchPad/Controller/Alternating-Current Control/PI/d-axis PI Regulator/Integrator */
  bool Integrator_2_prevReset;         /* /LaunchPad/Controller/Alternating-Current Control/PI/d-axis PI Regulator/Integrator */
  double Integrator_3_x;               /* /LaunchPad/Controller/Alternating-Current Control/PI/q-axis PI Regulator/Integrator */
  bool Integrator_3_prevReset;         /* /LaunchPad/Controller/Alternating-Current Control/PI/q-axis PI Regulator/Integrator */
  double StateMachine[3];              /* /LaunchPad/State Machine */
} LaunchPad_ModelStates;

extern LaunchPad_ModelStates LaunchPad_X;

/* Block outputs */
typedef struct {
  double Saturation;                   /* /LaunchPad/ADC Decode/Saturation */
  double TriangularWave;               /* /LaunchPad/Controller/Alternating-Voltage Control/Triangular Wave */
  double Saturation1;                  /* /LaunchPad/Controller/Modulator/Saturation1 */
  double Saturation_1[3];              /* /LaunchPad/Controller/Modulator/Saturation */
  double StateMachine[7];              /* /LaunchPad/State Machine */
  double Fcn;                          /* /LaunchPad/ADC Decode/Calibration V_ac/Fcn */
  double Cos;                          /* /LaunchPad/Controller/Alternating-Voltage Control/3ph->RRF7/Cos */
  double Fcn1;                         /* /LaunchPad/ADC Decode/Calibration V_ac/Fcn1 */
  double Sin;                          /* /LaunchPad/Controller/Alternating-Voltage Control/3ph->RRF7/Sin */
  double Fcn2;                         /* /LaunchPad/ADC Decode/Calibration V_ac/Fcn2 */
  double abc_d;                        /* /LaunchPad/Controller/Alternating-Voltage Control/3ph->RRF7/abc->d */
  double Sum;                          /* /LaunchPad/Controller/Alternating-Voltage Control/Sum */
  double SW_1;                         /* /LaunchPad/SW_1 */
  double Integrator;                   /* /LaunchPad/Controller/Alternating-Voltage Control/d-axis PI Regulator/Integrator */
  double abc_q;                        /* /LaunchPad/Controller/Alternating-Voltage Control/3ph->RRF7/abc->q */
  double Sum7;                         /* /LaunchPad/Controller/Alternating-Voltage Control/Sum7 */
  double Sum2;                         /* /LaunchPad/Controller/Alternating-Voltage Control/Sum2 */
  double Integrator_1;                 /* /LaunchPad/Controller/Alternating-Voltage Control/q-axis PI Regulator/Integrator */
  double Sum8;                         /* /LaunchPad/Controller/Alternating-Voltage Control/Sum8 */
  double Delay[3];                     /* /LaunchPad/Controller/Delay */
  double Cos_1;                        /* /LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF8/Cos */
  double Sin_1;                        /* /LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF8/Sin */
  bool Switch;                         /* /LaunchPad/Controller/Alternating-Current Control/PI/Switch */
  double Fcn_1;                        /* /LaunchPad/ADC Decode/Calibration I_ac/Fcn */
  double Cos_2;                        /* /LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF7/Cos */
  double Fcn1_1;                       /* /LaunchPad/ADC Decode/Calibration I_ac/Fcn1 */
  double Sin_2;                        /* /LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF7/Sin */
  double Fcn2_1;                       /* /LaunchPad/ADC Decode/Calibration I_ac/Fcn2 */
  double abc_d_1;                      /* /LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF7/abc->d */
  double Sum_1;                        /* /LaunchPad/Controller/Alternating-Current Control/PI/Sum */
  double Integrator_2;                 /* /LaunchPad/Controller/Alternating-Current Control/PI/d-axis PI Regulator/Integrator */
  double abc_q_1;                      /* /LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF7/abc->q */
  double Sum9;                         /* /LaunchPad/Controller/Alternating-Current Control/PI/Sum9 */
  double Cos_3;                        /* /LaunchPad/Controller/Alternating-Current Control/PI/RRF->SRF/Cos */
  double Sum2_1;                       /* /LaunchPad/Controller/Alternating-Current Control/PI/Sum2 */
  double Integrator_3;                 /* /LaunchPad/Controller/Alternating-Current Control/PI/q-axis PI Regulator/Integrator */
  double Sum10;                        /* /LaunchPad/Controller/Alternating-Current Control/PI/Sum10 */
  double Sin_3;                        /* /LaunchPad/Controller/Alternating-Current Control/PI/RRF->SRF/Sin */
  double dq_alpha;                     /* /LaunchPad/Controller/Alternating-Current Control/PI/RRF->SRF/dq->alpha */
  double dq_beta;                      /* /LaunchPad/Controller/Alternating-Current Control/PI/RRF->SRF/dq->beta */
  double Fcn_2;                        /* /LaunchPad/ADC Decode/Calibration V_dc/Fcn */
  double Sum_2[3];                     /* /LaunchPad/Controller/Modulator/[-1 1] -> [0 1]/Sum */
  bool Switch_1;                       /* /LaunchPad/Controller/Switch */
  bool LogicalOperator5;               /* /LaunchPad/Protection/Logical Operator5 */
  double Gain2;                        /* /LaunchPad/Controller/Alternating-Voltage Control/d-axis PI Regulator/Gain2 */
  double Gain2_1;                      /* /LaunchPad/Controller/Alternating-Voltage Control/q-axis PI Regulator/Gain2 */
  double Cos_4;                        /* /LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF9/Cos */
  double Sin_4;                        /* /LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF9/Sin */
  double Gain2_2;                      /* /LaunchPad/Controller/Alternating-Current Control/PI/d-axis PI Regulator/Gain2 */
  double Gain2_3;                      /* /LaunchPad/Controller/Alternating-Current Control/PI/q-axis PI Regulator/Gain2 */
} LaunchPad_BlockOutputs;

extern LaunchPad_BlockOutputs LaunchPad_B;

/* Entry point functions */
void LaunchPad_initialize(double time);
void LaunchPad_step(void);
void LaunchPad_terminate(void);

#endif                                 /* PLECS_HEADER_LaunchPad_h_ */
